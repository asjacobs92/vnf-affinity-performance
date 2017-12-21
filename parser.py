
import csv

from affinity import *

vnf_ids = {"fw": 1, "ids": 2, "dpi": 3}

sfc = '02'


def parse_vnf(row):
    time = int(row[0])
    test = int(row[1])
    net = row[2]
    vnf_id = vnf_ids[row[3]]
    vnf_type = row[3]
    vnf_pm = int(row[4])
    vnf_fg = int(row[5])
    flavor_data = row[6:9]
    vm_data = row[9:12]
    usage_data = row[12:15]

    pm = PhysicalMachine(vnf_pm)
    flavor = Flavor(min_cpu=float(flavor_data[0]), min_mem=float(flavor_data[1]), min_sto=float(flavor_data[2]))
    vnf = VNF(pm, flavor,
              id=vnf_id,
              fg_id=vnf_fg,
              type=next((x for x in VNF.types if vnf_type == x[0])),
              vm_cpu=float(vm_data[0]),
              vm_mem=float(vm_data[1]),
              vm_sto=float(vm_data[2]),
              cpu_usage=float(usage_data[0]) * 100,
              mem_usage=float(usage_data[1]) * 100,
              sto_usage=float(usage_data[2]) * 100)
    vnf.time = time
    vnf.net = net
    vnf.test = test

    return vnf


def parse_vnfs():
    vnfs = []
    final_vnfs = []
    with open("res/sec/summary-vnfs-" + sfc + ".csv", "rb") as file:
        reader = csv.reader(file, delimiter=",")
        for row in reader:
            vnfs.append(parse_vnf(row))

    mean_vnfs = {}
    for vnf in vnfs:
        if (vnf.id, vnf.time, vnf.net) in mean_vnfs:
            mean_vnfs[(vnf.id, vnf.time, vnf.net)].append(vnf)
        else:
            mean_vnfs[(vnf.id, vnf.time, vnf.net)] = [vnf]

    for (vnf_id, vnf_time, vnf_net), vnfs_list in mean_vnfs.iteritems():
        mean_vnf = None
        for vnf in vnfs_list:
            if (mean_vnf is None):
                mean_vnf = vnf
            else:
                mean_vnf.cpu_usage += vnf.cpu_usage
                mean_vnf.mem_usage += vnf.mem_usage
                mean_vnf.sto_usage += vnf.sto_usage

            mean_vnf.cpu_usage = mean_vnf.cpu_usage / 30.0
            mean_vnf.mem_usage = mean_vnf.mem_usage / 30.0
            mean_vnf.sto_usage = mean_vnf.sto_usage / 30.0

        final_vnfs.append(mean_vnf)
    return final_vnfs


def parse_fgs():
    fgs = []
    final_fgs = {}
    with open("res/sec/summary-fgs-" + sfc + ".csv", "rb") as file:
        reader = csv.reader(file, delimiter=",")
        for row in reader:
            time = int(row[0])
            test = int(row[1])
            net = row[2]
            fg_id = int(row[3])
            fg_num_flows = int(row[4])
            fg_rt = float(row[5])
            fg_thr = float(row[6])
            flows = []
            nsd = None
            for i in range(fg_num_flows):
                flow_data = next(reader)
                flow = Flow(
                    src=vnf_ids[flow_data[0]],
                    dst=vnf_ids[flow_data[1]],
                    trf=float(flow_data[2]),
                    lat=float(flow_data[3]),
                    bnd_usage=float(flow_data[4]) * 100,
                    pkt_loss=float(flow_data[5]))
                flows.append(flow)
                if (nsd is None):
                    nsd = NSD(sla=float(flow_data[6]))

            fg = ForwardingGraph(fg_id, flows=flows, nsd=nsd, rt=fg_rt, thr=fg_thr)
            fg.time = time
            fg.test = test
            fg.net = net
            fgs.append(fg)

    mean_fgs = {}
    for fg in fgs:
        if (fg.id, fg.time, fg.net) in mean_fgs:
            mean_fgs[(fg.id, fg.time, fg.net)].append(fg)
        else:
            mean_fgs[(fg.id, fg.time, fg.net)] = [fg]

    for (fg_id, fg_time, fg_net), fgs_list in mean_fgs.iteritems():
        mean_flows = {}
        mean_rt = -1
        mean_thr = -1
        nsd = None
        for fg in fgs_list:
            if (mean_rt == -1):
                mean_rt = fg.rt
                mean_thr = fg.thr
                nsd = fg.nsd
            else:
                mean_rt += fg.rt
                mean_thr += fg.thr

            for flow in fg.flows:
                if (fg_time, fg_net, flow.src, flow.dst) in mean_flows:
                    mean_flows[(fg_time, fg_net, flow.src, flow.dst)].append(flow)
                else:
                    mean_flows[(fg_time, fg_net, flow.src, flow.dst)] = [flow]

        final_flows = {}
        for (fg_time, fg_net, flow_src, flow_dst), flows_list in mean_flows.iteritems():
            for flow in flows_list:
                if (fg_time, fg_net, flow_src, flow_dst) in final_flows:
                    final_flows[(fg_time, fg_net, flow.src, flow.dst)].traffic += flow.traffic
                    final_flows[(fg_time, fg_net, flow.src, flow.dst)].latency += flow.latency
                    final_flows[(fg_time, fg_net, flow.src, flow.dst)].bnd_usage += flow.bnd_usage
                    final_flows[(fg_time, fg_net, flow.src, flow.dst)].pkt_loss += flow.pkt_loss
                else:
                    final_flows[(fg_time, fg_net, flow.src, flow.dst)] = flow

        for (fg_time, fg_net, flow_src, flow_dst), flow in final_flows.iteritems():
            flow.traffic = flow.traffic / 30.0
            flow.latency = flow.latency / 30.0
            flow.bnd_usage = flow.bnd_usage / 30.0
            flow.pkt_loss = flow.pkt_loss / 30.0

        fg = ForwardingGraph(fg_id, flows=final_flows.values(), nsd=nsd, rt=mean_rt / 30.0, thr=mean_thr / 30.0)
        final_fgs[(fg_id, fg_time, fg_net)] = fg

    return final_fgs
