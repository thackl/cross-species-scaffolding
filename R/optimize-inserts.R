##
library(dplyr)

df <- read.table(text="chr1    100088228   100162167   AGL
chr1    107599438   107600565   PRMT6
chr1    115215635   115238091   AMPD1
chr1    11850637    11863073    MTHFR
chr1    119958143   119965343   HSD3B2
chr1    144124628   144128902   HFE2
chr1    150769175   150779181   CTSK
chr1    154245300   154248277   HAX1
chr1    155204686   155210803   GBA
chr1    156084810   156108997   LMNA", stringsAsFactors=FALSE)

coo.df <- read.table("consensus-coords.bed")
colnames(coo.df) <- c("chr", "start", "end")
coo.df$id <- 1:length(coo.df$chr)


getInter <- function(x, data){
    t1 <- filter(data, x >= start, x <= end)
    t2 <- filter(data, (x+is) >= start, (x+is) <= end)

    if(nrow(t1) && nrow(t2) && t1$start != t2$start){ c(t1$id,t2$id) }else{ c(NA,NA)}
}


chr.len <- max(coo.df[,3]);
read.len <- 100  # assume read len 100, so I need 50 pairs for 100X
cov <- 1
is <- 1500
read.n <- chr.len/(2*read.len/cov) # pairs

m1 <- round(seq.int(from=1, to=chr.len-is, length.out=read.n))


str(coo.df)
str(m1)
seqs.linked <- as.vector(t(sapply(m1, getInter, data=coo.df, simplify=T)))
seqs.linked <- na.omit(seqs.linked)
seqs.linked.t <- table(seqs.linked)
seqs.linked.t[seqs.linked.t >3]


