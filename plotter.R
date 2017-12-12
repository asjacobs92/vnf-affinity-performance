
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


m <- ggplot(data = ids_fw, aes(x=net, y=throughput, group=factor(sfc), linetype=factor(sfc), color=factor(sfc))) 
m +
  geom_line() +
  scale_linetype(labels=c("SFC 1","SFC 2")) +
  xlab("Bandwidth (Mbps)") +ylab("Response Time (ms)") +
  scale_x_discrete("Net") +
  theme(axis.line.x = element_line(color = 'black'),
        axis.line.y = element_line(color = 'black'),
        legend.justification=c(0,1), 
        legend.position=c(0,1),
        panel.border = element_blank(),
        legend.title=element_blank(),
        axis.text = element_text(size = 16), 
        axis.title = element_text(size = 16),
        text = element_text(size = 16)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.title = element_text(colour="black", size=10, face="bold"), legend.position="right", legend.title.align=0.5)

#GUILTINESS
p <- ggplot(data=tr_summarized, aes(x=g.vm1, y=g.vm2,fill=Mean,size=Mean))
p +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("G" [vnf [1]] ))))  +ylab(expression(italic(paste("G" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("Fig4d.pdf",height=6,width = 6)

model <- lm(data=tr_summarized, rtNorm~ (I(tr_summarized$sumUsage)+sumActive+I(1/(1.01-sumQueueUsage))+I((sumActive)/(1+sumQueue)))-1) 
summary(model)

rSquared <- round(summary(model)$r.squared,digits=2)

c1 <- summary(model)$coef[,"Estimate",drop=F][1,1]
c2 <- summary(model)$coef[,"Estimate",drop=F][2,1]
c3 <- summary(model)$coef[,"Estimate",drop=F][3,1]
c4 <- summary(model)$coef[,"Estimate",drop=F][4,1]

tr_summarized$g.vm1=1*(c4*(tr_summarized$a.vm1/(1+tr_summarized$q.vm1))+c1*(1/(1.01-(tr_summarized$u.vm1)))+c2*tr_summarized$a.vm1+c3*tr_summarized$qu.vm1)
tr_summarized$g.vm2=1*(c4*(tr_summarized$a.vm2/(1+tr_summarized$q.vm2))+c1*(1/(1.01-(tr_summarized$u.vm2)))+c2*tr_summarized$a.vm2+c3*tr_summarized$qu.vm2)
tr_summarized$g.vm1[tr_summarized$g.vm1 >= 1] <- 1.0
tr_summarized$g.vm2[tr_summarized$g.vm2 >= 1] <- 1.0
tr_summarized$estimated=1*(c4*(tr_summarized$sumActive/(1+tr_summarized$sumQueue))+c1*tr_summarized$sumUsage+c2*tr_summarized$sumActive+c3*tr_summarized$sumQueueUsage) 
tr_summarized$estimated[tr_summarized$estimated >= 1] <- 1.0

rSquared <- paste("R-squared = ",rSquared)

m <- ggplot(data = tr_summarized, aes(x=rtNorm, y=estimated)) 
m  + scale_x_continuous(limits=c(0,1),breaks=seq(0, 1, by=0.1)) + 
  scale_y_continuous(limits=c(0,1),breaks=seq(0, 1, by=0.1))+
  theme_bw() +  
  annotate("text", x = 0.455, y = 0.505, label =rSquared, angle = 45, size=9)+
  geom_point(data=tr_summarized,aes(y=(estimated)), size=4, shape=1) +
  xlab("Normalized response time") +ylab("Guiltiness estimative") +
  theme(axis.line.x = element_line(color = 'black'),axis.line.y = element_line(color = 'black'),legend.justification=c(0,1), legend.position=c(0,1),legend.title=element_blank(),axis.text = element_text(size = 24), axis.title = element_text(size = 24),text = element_text(size = 24)) +  
  theme(
    plot.background = element_blank()
    ,panel.border = element_blank()
  ) +
  scale_colour_grey(end=0) +
  geom_abline(intercept = 0)

ggsave("Fig5b.pdf",height=8,width = 8)

#GUILTINESS
p <- ggplot(data=tr_summarized, aes(x=g.vm1, y=g.vm2,fill=Mean,size=Mean))
p +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("G" [vnf [1]] ))))  +ylab(expression(italic(paste("G" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("guiltinessRegression.pdf",height=6,width = 6)

#FROM LEARNING SERVER
learnerCoeff <- read.csv("historic.csv",header=FALSE)
c1 <- learnerCoeff[1,1]
c2 <- learnerCoeff[1,2]
c3 <- learnerCoeff[1,3]
c4 <- learnerCoeff[1,4]

rSquared <- round(learnerCoeff[1,5],digits=2)
rSquared <- paste("R-squared = ",rSquared)

tr_summarized$g.vm1=1*(c4*(tr_summarized$a.vm1/(1+tr_summarized$q.vm1))+c1*(1/(1.01-(tr_summarized$u.vm1)))+c2*tr_summarized$a.vm1+c3*tr_summarized$qu.vm1)
tr_summarized$g.vm2=1*(c4*(tr_summarized$a.vm2/(1+tr_summarized$q.vm2))+c1*(1/(1.01-(tr_summarized$u.vm2)))+c2*tr_summarized$a.vm2+c3*tr_summarized$qu.vm2)
tr_summarized$g.vm1[tr_summarized$g.vm1 >= 1] <- 1.0
tr_summarized$g.vm2[tr_summarized$g.vm2 >= 1] <- 1.0
tr_summarized$estimated=1*(c4*(tr_summarized$sumActive/(1+tr_summarized$sumQueue))+c1*tr_summarized$sumUsage+c2*tr_summarized$sumActive+c3*tr_summarized$sumQueueUsage) 
tr_summarized$estimated[tr_summarized$estimated >= 1] <- 1.0

m <- ggplot(data = tr_summarized, aes(x=rtNorm, y=estimated)) 
m  + scale_x_continuous(limits=c(0,1),breaks=seq(0, 1, by=0.1)) + 
  scale_y_continuous(limits=c(0,1),breaks=seq(0, 1, by=0.1))+
  theme_bw() +  
  annotate("text", x = 0.455, y = 0.505, label =rSquared, angle = 45, size=9)+
  geom_point(data=tr_summarized,aes(y=(estimated)), size=4, shape=1) +
  xlab("Normalized response time") +ylab("Guiltiness estimative") +
  theme(axis.line.x = element_line(color = 'black'),axis.line.y = element_line(color = 'black'),legend.justification=c(0,1), legend.position=c(0,1),legend.title=element_blank(),axis.text = element_text(size = 24), axis.title = element_text(size = 24),text = element_text(size = 24)) +  
  theme(
    plot.background = element_blank()
    ,panel.border = element_blank()
  ) +
  scale_colour_grey(end=0) +
  geom_abline(intercept = 0)

ggsave("learnerCoeff.pdf",height=8,width = 8)


#GUILTINESS
p <- ggplot(data=tr_summarized, aes(x=g.vm1, y=g.vm2,fill=Mean,size=Mean))
p +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("G" [vnf [1]] ))))  +ylab(expression(italic(paste("G" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("guiltinessLearner.pdf",height=6,width = 6)

#USAGE
p1 <- ggplot(data=tr_summarized, aes(x=u.vm1, y=u.vm2,fill=Mean,size=Mean))
p1 +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("U" [vnf [1]] ))))  +ylab(expression(italic(paste("U" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("Fig4a.pdf",height=6,width = 6)

#Active
p1 <- ggplot(data=tr_summarized, aes(x=a.vm1, y=a.vm2,fill=Mean,size=Mean))
p1 +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("A" [vnf [1]] ))))  +ylab(expression(italic(paste("A" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("Fig4b.pdf",height=6,width = 6)

#Queue
p1 <- ggplot(data=tr_summarized, aes(x=qu.vm1, y=qu.vm2,fill=Mean,size=Mean))
p1 +     stat_contour() +
  geom_jitter(position=position_jitter(w=0, h=0),shape=21) +
  scale_fill_gradient2(name="RT",low="white",mid="gray",high="black")+
  geom_tile(aes(fill = Mean)) +
  guides(size=FALSE)+
  scale_x_continuous(limits=c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(limits = c(0,1), breaks=seq(0,1,by=0.1)) +
  scale_size_area(breaks=seq(0,4,by=0.2),max_size=16)+
  xlab(expression(italic(paste("Qu" [vnf [1]] ))))  +ylab(expression(italic(paste("Qu" [vnf [2]] )))) +
  theme_bw() +
  theme(legend.text = element_text( size = 16),legend.position=c(0.92,0.85),axis.text = element_text(size = 20), axis.title = element_text(size = 20),text = element_text(size = 20))   

ggsave("Fig4c.pdf",height=6,width = 6)
