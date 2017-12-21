
library(ggplot2)
library(plyr)
library(Rmisc)
library(gtools)

#read collected results
data <- read.csv("/home/asjacobs/workspace/vnf-affinity-performance/res/sec/results-02.csv")
data$time <- as.numeric(data$time)
data$rt <- as.numeric(data$rt)
data$throughput <- as.numeric(data$throughput)
data[with(data, order(time)), ]

ids_fw <- data[data$vnf_a %in% c('ids.5.2', 'fw.3.1') & data$vnf_b %in% c('ids.5.2', 'fw.3.1'),]
ids_fw[with(ids_fw, order(time)), ]
fw_dpi <- data[data$vnf_a %in% c('dpi.2.3', 'fw.3.1') & data$vnf_b %in% c('dpi.2.3', 'fw.3.1'),]
fw_dpi[with(fw_dpi, order(time)), ]
ids_dpi <- data[data$vnf_a %in% c('dpi.2.3', 'ids.5.2') & data$vnf_b %in% c('dpi.2.3', 'ids.5.2'),]
ids_dpi[with(ids_dpi, order(time)), ]

temp <- summarySE(ids_fw, measurevar="rt", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=rt, colour=factor(sfc), group=factor(sfc), linetype=factor(sfc))) 
m + geom_errorbar(aes(ymin=rt-ci, ymax=rt+ci), colour="black", width=2, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  scale_x_continuous(limits = c(0,101), breaks=c(10,50,100)) +
  scale_y_continuous(limits = c(0,0.6), breaks=seq(0,0.6,by=0.10)) +
  xlab("Bandwidth (Mbps)") +ylab("Response Time (ms)") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(linetype='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

    

temp <- summarySE(ids_fw, measurevar="throughput", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=throughput, colour=factor(sfc), group=factor(sfc), linetype=factor(sfc))) 
m + geom_errorbar(aes(ymin=throughput-ci, ymax=throughput+ci), colour="black", width=2, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  scale_y_continuous(limits = c(0,80), breaks=seq(0,80,by=10)) +
  scale_x_continuous(limits = c(0,101), breaks=c(10,50,100)) +
  xlab("Bandwidth (Mbps)") +ylab("Throughput (req/s)") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  labs(linetype='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(ids_fw, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, colour=factor(sfc), group=factor(sfc), linetype=factor(sfc))) 
m + geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=2, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  scale_x_continuous(limits = c(0,101), breaks=c(10,50,100)) +
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
  labs(linetype='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(fw_dpi, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, colour=factor(sfc), group=factor(sfc), linetype=factor(sfc))) 
m + geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=2, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,0.1)) +
  scale_x_continuous(limits = c(0,101), breaks=c(10,50,100)) +
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
  labs(linetype='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)


temp <- summarySE(ids_dpi, measurevar="total_affinity", groupvars=c("net","sfc"))
pd <- position_dodge(0.1) # move them .05 to the left and right
# Black error bars - notice the mapping of 'group=supp' -- without it, the error
# bars won't be dodged!
m <- ggplot(temp, aes(x=net, y=total_affinity, colour=factor(sfc), group=factor(sfc), linetype=factor(sfc))) 
m + geom_errorbar(aes(ymin=total_affinity-ci, ymax=total_affinity+ci), colour="black", width=2, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  scale_x_continuous(limits = c(0,101), breaks=c(10,50,100)) +
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
  labs(linetype='SFC', color='SFC') +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

