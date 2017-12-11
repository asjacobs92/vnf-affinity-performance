from random import *

import numpy
import scipy

from debug import *


class Criterion(object):
    def __init__(self, name, type, scope, weight, formula):
        self.name = name
        self.type = type
        self.scope = scope
        self.formula = formula
        self.weight = weight


class VNF(object):
    types = [
        ('load balancer', 1, 0.1),
        ('dpi', 2, 0.2),
        ('fw', 3, 0.3),
        ('ips', 4, 0.4),
        ('ids', 5, 0.5),
        ('nat', 6, 0.6),
        ('traffic counter', 7, 0.7),
        ('cache', 8, 0.8),
        ('proxy', 9, 0.9)
    ]

    def __init__(self, pm, flavor, id=0, type=0, vm_cpu=0, vm_mem=0, vm_sto=0, cpu_usage=0, mem_usage=0, sto_usage=0, fg_id=0):
        self.id = id
        self.type = type
        self.vm_cpu = vm_cpu
        self.vm_mem = vm_mem
        self.vm_sto = vm_sto

        self.cpu_usage = cpu_usage
        self.mem_usage = mem_usage
        self.sto_usage = sto_usage

        self.label = str(self.type[0]) + "." + str(self.type[1]) + "." + str(self.id)
        self.pm = pm
        self.flavor = flavor
        self.fg_id = fg_id
        self.fgs = []

    def find_fgs(self, fgs):
        try:
            self.fgs.append(fgs[self.fg_id])
            return True
        except:
            print False
            return False


class PhysicalMachine(object):
    def __init__(self, id=0, cpu=0.5, mem=0.5, sto=0.5):
        self.id = id
        self.cpu = cpu
        self.mem = mem
        self.sto = sto


class ForwardingGraph(object):
    def __init__(self, id=0, flows=None, nsd=None, rt=0, thr=0):
        self.id = id
        self.label = "fg"
        self.flows = flows
        self.nsd = nsd
        self.rt = rt
        self.thr = thr


class Flow(object):
    class_sequence = 1

    def __init__(self, src, dst, trf=0, lat=0, bnd_usage=0, pkt_loss=0):
        self.id = Flow.class_sequence
        self.src = src
        self.dst = dst
        self.traffic = trf
        self.latency = lat
        self.bnd_usage = bnd_usage
        self.pkt_loss = pkt_loss
        Flow.class_sequence += 1


class Flavor(object):
    class_sequence = 1

    def __init__(self, id=0, min_cpu=0, min_mem=0, min_sto=0):
        self.id = Flavor.class_sequence if id == 0 else id
        self.min_cpu = min_cpu
        self.min_mem = min_mem
        self.min_sto = min_sto
        Flavor.class_sequence += 1


class NSD(object):
    def __init__(self, sla=0.0, conflicts=[]):
        self.sla = numpy.random.uniform(0, 1, 1)[0] * 50 if (sla == 0.0) else sla
        self.conflicts = conflicts
