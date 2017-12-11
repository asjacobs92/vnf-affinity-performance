
import csv

from affinity import *

vnf_ids = {"fw": 1, "ids": 2, "dpi": 3}

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

    return time, test, net, VNF(pm, flavor,
                                   id=vnf_id,
                                   fg_id=vnf_fg,
                                   type=next((x for x in VNF.types if vnf_type == x[0])),
                                   vm_cpu=float(vm_data[0]),
                                   vm_mem=float(vm_data[1]),
                                   vm_sto=float(vm_data[2]),
                                   cpu_usage=float(usage_data[0]),
                                   mem_usage=float(usage_data[1]),
                                   sto_usage=float(usage_data[2]))


def parse_vnfs():
    vnfs = {}
    with open("res/sec/summary-vnfs-03.csv", "rb") as file:
        reader = csv.reader(file, delimiter=",")
        for row in reader:
            time, test, net, vnf = parse_vnf(row)
            if (vnf is not None):
                if ((time, test, net) in vnfs):
                    vnfs[(time, test, net)].append(vnf)
                else:
                    vnfs[(time, test, net)] = [vnf]

    return vnfs


def parse_fgs():
    fgs = {}
    with open("res/sec/summary-fgs-03.csv", "rb") as file:
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
                flow = Flow(vnf_ids[flow_data[0]], vnf_ids[flow_data[1]], float(flow_data[2]), float(flow_data[3]), float(flow_data[4]), float(flow_data[5]))
                flows.append(flow)
                if (nsd is None):
                    nsd = NSD(sla=float(flow_data[6]))

            if ((time, test, net) in fgs):
                fgs[(time, test, net)][fg_id] = ForwardingGraph(fg_id, flows=flows, nsd=nsd, rt=fg_rt, thr=fg_thr)
            else:
                fgs[(time, test, net)] = {fg_id: ForwardingGraph(fg_id, flows=flows, nsd=nsd, rt=fg_rt, thr=fg_thr)}

    return fgs
