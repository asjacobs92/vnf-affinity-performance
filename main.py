import sys
from math import *
from parser import *
from time import *

from affinity import *

vnfs = []

sfc = '03'


def read():
    global vnfs

    vnfs = parse_vnfs()
    fgs = parse_fgs()

    for vnf in vnfs:
        vnf.find_fgs(fgs)


def write():
    with open("res/sec/results-" + sfc + ".csv", "wb") as file:
        writer = csv.writer(file, delimiter=",")
        writer.writerow(
            [
                "sfc",
                "time",
                "net",
                "vnf_a",
                "vnf_a_cpu",
                "vnf_a_mem",
                "vnf_a_sto",
                "vnf_b",
                "vnf_b_cpu",
                "vnf_b_mem",
                "vnf_b_sto",
                "traffic",
                "latency",
                "bnd_usage",
                "pkt_loss",
                "rt",
                "throughput",
                "min_cpu_affinity",
                "min_mem_affinity",
                "min_sto_affinity",
                "conflicts_affinity",
                "cpu_usage_affinity",
                "mem_usage_affinity",
                "sto_usage_affinity",
                "bnd_usage_affinity",
                "pkt_loss_affinity",
                "lat_affinity",
                "static_pm_affinity",
                "static_fg_affinity",
                "dynamic_pm_affinity",
                "dynamic_fg_affinity",
                "static_affinity",
                "trf_affinity",
                "network_affinity",
                "dynamic_affinity",
                "total_affinity",
            ]
        )

        tests = {}
        for time in range(1, 120):
            for net in ["10Mbps", "50Mbps", "100Mbps"]:
                tests[(time, net)] = [x for x in vnfs if x.time == time and x.net == net]

        for (time, net), vnf_list in tests.iteritems():
            vnf_list.sort(key=lambda x: x.id, reverse=False)
            for i in range(0, len(vnf_list) - 1):
                for j in range(i + 1, len(vnf_list)):
                    vnf_a = vnf_list[i]
                    vnf_b = vnf_list[j]
                    fg = vnf_a.fgs[0]
                    flow = None
                    if (fg is not None):
                        flow = next((x for x in fg.flows if ((x.src == vnf_a.id and x.dst == vnf_b.id) or (x.src == vnf_b.id and x.dst == vnf_a.id))), None)
                    affinity = affinity_measurement(vnf_a, vnf_b, fg)["result"]

                    writer.writerow(
                        [
                            int(sfc),
                            time,
                            net.replace("Mbps", ""),
                            vnf_a.label,
                            vnf_a.cpu_usage / 100,
                            vnf_a.mem_usage / 100,
                            vnf_a.sto_usage / 100,
                            vnf_b.label,
                            vnf_b.cpu_usage / 100,
                            vnf_b.mem_usage / 100,
                            vnf_b.sto_usage / 100,
                            flow.traffic if flow is not None else 0,
                            flow.latency if flow is not None else 0,
                            flow.bnd_usage / 100 if flow is not None else 0,
                            flow.pkt_loss / 100 if flow is not None else 0,
                            fg.rt,
                            fg.thr,
                            min_cpu_affinity(vnf_a, vnf_b, fg),
                            min_mem_affinity(vnf_a, vnf_b, fg),
                            min_sto_affinity(vnf_a, vnf_b, fg),
                            conflicts_affinity(vnf_a, vnf_b, fg),
                            cpu_usage_affinity(vnf_a, vnf_b, fg),
                            mem_usage_affinity(vnf_a, vnf_b, fg),
                            sto_usage_affinity(vnf_a, vnf_b, fg),
                            bnd_usage_affinity(vnf_a, vnf_b, fg),
                            pkt_loss_affinity(vnf_a, vnf_b, fg),
                            lat_affinity(vnf_a, vnf_b, fg),
                            static_pm_affinity(vnf_a, vnf_b, fg),
                            static_fg_affinity(vnf_a, vnf_b, fg),
                            dynamic_pm_affinity(vnf_a, vnf_b, fg),
                            dynamic_fg_affinity(vnf_a, vnf_b, fg),
                            static_affinity(vnf_a, vnf_b, fg),
                            trf_affinity(vnf_a, vnf_b, fg),
                            network_affinity(vnf_a, vnf_b, fg),
                            dynamic_affinity(vnf_a, vnf_b, fg),
                            total_affinity(vnf_a, vnf_b, fg)
                        ]
                    )


if __name__ == "__main__":
    print "Starting read"
    read()
    print "Starting write"
    write()
