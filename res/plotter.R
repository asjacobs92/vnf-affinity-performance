
library(ggplot2)
library(plyr)
library(Rmisc)
library(gtools)
library(reshape2)
library(gtools)

#read collected results
data <- read.csv("/home/asjacobs/workspace/vnf-affinity-performance/res/sec/results-01.csv")
data$time <- as.numeric(data$time)
data$rt <- as.numeric(data$rt)
data$throughput <- as.numeric(data$throughput)
data[with(data, order(time)), ]

data$pair[data$vnf_a %in% c('ids.5.2', 'fw.3.1') & data$vnf_b %in% c('ids.5.2', 'fw.3.1')] <- "fw_ids"
data$pair[data$vnf_a %in% c('dpi.2.3', 'fw.3.1') & data$vnf_b %in% c('dpi.2.3', 'fw.3.1')] <- "fw_dpi"
data$pair[data$vnf_a %in% c('dpi.2.3', 'ids.5.2') & data$vnf_b %in% c('dpi.2.3', 'ids.5.2')] <- "dpi_ids"

ids_fw <- data[data$pair == "fw_ids",]
ids_fw[with(ids_fw, order(time)), ]
fw_dpi <- data[data$pair == "fw_dpi",]
fw_dpi[with(fw_dpi, order(time)), ]
ids_dpi <- data[data$pair == "dpi_ids",]
ids_dpi[with(ids_dpi, order(time)), ]

net10 <- data[data$net == "10",]
net10[with(net10, order(time)), ]
net50 <- data[data$net == "50",]
net50[with(net50, order(time)), ]
net100 <- data[data$net == "100",]
net100[with(net100, order(time)), ]

temp <- summarySE(ids_fw, measurevar="rt", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=rt, group=factor(sfc))) 
m + 
  geom_bar(aes(fill=factor(sfc)),position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=rt-ci, ymax=rt+ci), colour="black", width=10, position=position_dodge(35)) +
  scale_x_continuous(limits = c(-10,120), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,0.4), breaks=seq(0,0.4,by=0.10)) +
  xlab("Bandwidth (Mbps)") +ylab("Response Time (ms)") +
  theme_bw() +  
  scale_fill_grey(start = 0.3, end = .6) +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

    

temp <- summarySE(ids_fw, measurevar="throughput", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=throughput, group=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=throughput-ci, ymax=throughput+ci), colour="black", width=10, position=position_dodge(35)) +
  scale_x_continuous(limits = c(-10,120), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,30), breaks=seq(0,30,by=10)) +
  xlab("Bandwidth (Mbps)") +ylab("Throughput (req/s)") +
  theme_bw() +  
  scale_fill_grey(start = 0.3, end = .6) +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(ids_fw, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, group=factor(sfc), fill=factor(sfc))) 
m +
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=10, position=position_dodge(35)) +
  scale_x_continuous(limits = c(-10,120), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  xlab("Bandwidth (Mbps)") + ylab("Affinity (FW x IDS)") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(fw_dpi, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, colour=factor(sfc), group=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=10, position=position_dodge(35)) +
  scale_x_continuous(limits = c(-10,120), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  xlab("Bandwidth (Mbps)") + ylab("Affinity (FW x DPI)") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(ids_dpi, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, colour=factor(sfc), group=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=10, position=position_dodge(35)) +
  scale_x_continuous(limits = c(-10,120), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  xlab("Bandwidth (Mbps)") + ylab("Affinity (IDS x DPI)") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)



temp1 <- summarySE(net10, measurevar="total_affinity", groupvars=c("sfc", "pair"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp1, aes(x=pair, y=total_affinity, group=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=0.3, position=position_dodge(0.9)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  xlab("VNF Pairs") + ylab("Total Affinity") +
  theme_bw() +  
  scale_fill_grey(start = 0.3, end = .6) +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp1 <- summarySE(net50, measurevar="total_affinity", groupvars=c("sfc", "pair"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp1, aes(x=pair, y=total_affinity, group=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=0.3, position=position_dodge(0.9)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  theme_bw() +  
  scale_fill_grey(start = 0.3, end = .6) +
  xlab("VNF Pairs") + ylab("Total Affinity") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

temp1 <- summarySE(net100, measurevar="total_affinity", groupvars=c("sfc", "pair"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp1, aes(x=pair, y=total_affinity, sgroup=factor(sfc), fill=factor(sfc))) 
m + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=0.3, position=position_dodge(0.9)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  theme_bw() +  
  scale_fill_grey(start = 0.3, end = .6) +
  xlab("VNF Pairs") + ylab("Total Affinity") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(fill='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

  
ids_fw$traffic <- ids_fw$traffic / max(ids_fw$traffic)
ids_fw$latency <- ids_fw$latency / max(ids_fw$latency)
meltdf <- melt(ids_fw, id.vars = c("time","net","sfc"), measure.vars = c("vnf_a_cpu", "vnf_b_cpu", "vnf_a_mem", "vnf_b_mem", "latency", "bnd_usage", "traffic"))

m <- ggplot(meltdf, aes(x=time, y=value, colour=variable, group=variable, linetype=variable)) 
m + 
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf)+
  facet_grid(sfc~net,switch = 'y')+
  scale_x_continuous(limits=c(0,120),breaks=seq(0, 120, by=10)) + 
  geom_line() +
  xlab("Time (s)") + ylab("Normalized measurement") +
  theme(axis.line.x = element_line(color = 'black'),axis.line.y = element_line(color = 'black'), legend.position="top",legend.title=element_blank(),axis.text = element_text(size = 12), axis.title = element_text(size = 12),text = element_text(size = 12)) +  
  theme(plot.background = element_blank(),panel.border = element_blank()) 



####################### FW x IDS #######################

colnames(ids_fw)[which(names(ids_fw) == "total_affinity")] <- "Affinity"
colnames(ids_fw)[which(names(ids_fw) == "traffic")] <- "Traffic"
colnames(ids_fw)[which(names(ids_fw) == "bnd_usage")] <- "Bandwidth Usage"
colnames(ids_fw)[which(names(ids_fw) == "latency")] <- "Latency"
colnames(ids_fw)[which(names(ids_fw) == "pkt_loss")] <- "Packet Loss"

colnames(ids_fw)[which(names(ids_fw) == "vnf_a_cpu")] <- "FW CPU Usage"
colnames(ids_fw)[which(names(ids_fw) == "vnf_b_cpu")] <- "IDS CPU Usage"
colnames(ids_fw)[which(names(ids_fw) == "vnf_a_mem")] <- "FW Memory Usage"
colnames(ids_fw)[which(names(ids_fw) == "vnf_b_mem")] <- "IDS Memory Usage"

ids_fw$traffic <- ids_fw$traffic / max(ids_fw$traffic)
ids_fw$latency <- ids_fw$latency / max(ids_fw$latency)
meltdf1 <- melt(ids_fw, id.vars = c("time","net","sfc"), measure.vars = c("Affinity", "Traffic", "Latency", "Bandwidth Usage", "Packet Loss"))


meltdf1$sfc[meltdf1$sfc == "1"] <- "SFC 1"
meltdf1$sfc[meltdf1$sfc == "2"] <- "SFC 2"

meltdf1$net[meltdf1$net == "10"] <- "10 Mbps"
meltdf1$net[meltdf1$net == "50"] <- "50 Mbps"
meltdf1$net[meltdf1$net == "100"] <- "100 Mbps"

meltdf1$net_f = factor(meltdf1$net, levels=c("10 Mbps","50 Mbps","100 Mbps"))


m <- ggplot(meltdf1, aes(x=time, y=value, colour=variable, group=variable, linetype=variable)) 
m + 
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf)+
  facet_grid(sfc~net_f)+
  scale_x_continuous(limits=c(0,120),breaks=seq(0, 120, by=40)) + 
  geom_line() +
  theme_bw() +  
  xlab("Time (s)") + ylab("Normalized measurement") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        plot.title = element_text(hjust = 0.5),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(colour="Measurement", group="Measurement", linetype="Measurement") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="top", legend.title.align=0.5)




####################### FW x DPI #######################

colnames(fw_dpi)[which(names(fw_dpi) == "total_affinity")] <- "Affinity"
colnames(fw_dpi)[which(names(fw_dpi) == "traffic")] <- "Traffic"
colnames(fw_dpi)[which(names(fw_dpi) == "bnd_usage")] <- "Bandwidth Usage"
colnames(fw_dpi)[which(names(fw_dpi) == "latency")] <- "Latency"
colnames(fw_dpi)[which(names(fw_dpi) == "pkt_loss")] <- "Packet Loss"


fw_dpi$traffic <- fw_dpi$traffic / max(fw_dpi$traffic)
fw_dpi$latency <- fw_dpi$latency / max(fw_dpi$latency)
meltdf2 <- melt(fw_dpi, id.vars = c("time","net","sfc"), measure.vars = c("Affinity", "Traffic", "Latency", "Bandwidth Usage", "Packet Loss"))


meltdf2$sfc[meltdf2$sfc == "1"] <- "SFC 1"
meltdf2$sfc[meltdf2$sfc == "2"] <- "SFC 2"

meltdf2$net[meltdf2$net == "10"] <- "10 Mbps"
meltdf2$net[meltdf2$net == "50"] <- "50 Mbps"
meltdf2$net[meltdf2$net == "100"] <- "100 Mbps"
meltdf2$net_f = factor(meltdf1$net, levels=c("10 Mbps","50 Mbps","100 Mbps"))


m <- ggplot(meltdf2, aes(x=time, y=value, colour=variable, group=variable, linetype=variable)) 
m + 
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf)+
  facet_grid(sfc~net_f)+
  scale_x_continuous(limits=c(0,120),breaks=seq(0, 120, by=40)) + 
  geom_line() +
  xlab("Time (s)") + ylab("Normalized measurement") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        plot.title = element_text(hjust = 0.5),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(colour="Measurement", group="Measurement", linetype="Measurement") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="top", legend.title.align=0.5)



####################### IDS x DPI #######################


colnames(ids_dpi)[which(names(ids_dpi) == "total_affinity")] <- "Affinity"
colnames(ids_dpi)[which(names(ids_dpi) == "traffic")] <- "Traffic"
colnames(ids_dpi)[which(names(ids_dpi) == "bnd_usage")] <- "Bandwidth Usage"
colnames(ids_dpi)[which(names(ids_dpi) == "latency")] <- "Latency"
colnames(ids_dpi)[which(names(ids_dpi) == "pkt_loss")] <- "Packet Loss"

ids_dpi$traffic <- ids_dpi$traffic / max(ids_dpi$traffic)
ids_dpi$latency <- ids_dpi$latency / max(ids_dpi$latency)
meltdf3 <- melt(ids_dpi, id.vars = c("time","net","sfc"), measure.vars = c("Affinity", "Traffic", "Latency", "Bandwidth Usage", "Packet Loss"))

meltdf3$sfc[meltdf3$sfc == "1"] <- "SFC 1"
meltdf3$sfc[meltdf3$sfc == "2"] <- "SFC 2"

meltdf3$net[meltdf3$net == "10"] <- "10 Mbps"
meltdf3$net[meltdf3$net == "50"] <- "50 Mbps"
meltdf3$net[meltdf3$net == "100"] <- "100 Mbps"
meltdf3$net_f = factor(meltdf1$net, levels=c("10 Mbps","50 Mbps","100 Mbps"))

m <- ggplot(meltdf3, aes(x=time, y=value, colour=variable, group=variable, linetype=variable)) 
m + 
  annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf)+
  annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf)+
  facet_grid(sfc~net_f)+
  scale_x_continuous(limits=c(0,120),breaks=seq(0, 120, by=40)) + 
  geom_line() +
  xlab("Time (s)") + ylab("Normalized measurement") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        plot.title = element_text(hjust = 0.5),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(colour="Measurement", group="Measurement", linetype="Measurement") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="top", legend.title.align=0.5)






