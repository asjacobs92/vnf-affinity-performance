import sys
from math import *
from parser import *
from time import *

from affinity import *

vnfs = []

sfc = '02'


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
                "vnf_b",
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
            for i in range(0, len(vnf_list) - 1):
                for j in range(i + 1, len(vnf_list)):
                    vnf_a = vnf_list[i]
                    vnf_b = vnf_list[j]
                    fg = vnf_a.fgs[0]
                    affinity = affinity_measurement(vnf_a, vnf_b, fg)["result"]

                    writer.writerow(
                        [
                            int(sfc) - 1,
                            time,
                            net.replace("Mbps", ""),
                            vnf_a.label,
                            vnf_b.label,
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
