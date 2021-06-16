# load data

  args <- commandArgs(trailingOnly=TRUE)
  setwd(args[1])
 
  id <- read.csv("id_list.csv", header = FALSE)
  wm_core_mean <- read.csv("wm_core_mean.csv", header = FALSE)
  wm_core_sd <- read.csv("wm_core_std.csv", header = FALSE)
  nonbrain_mean <- read.csv("nonbrain_mean.csv", header = FALSE)
  nonbrain_sd <- read.csv("nonbrain_std.csv", header = FALSE)
  nonwm_mean <- read.csv("nonwm_mean.csv", header = FALSE)
  nonwm_sd <- read.csv("nonwm_std.csv", header = FALSE)
  invb_mean <- read.csv("inv_brain_mean.csv", header = FALSE)
  invb_sd <- read.csv("inv_brain_sd.csv", header = FALSE)
  
  all.data <- cbind(id, wm_core_mean, wm_core_sd, nonbrain_mean, nonbrain_sd, nonwm_mean, nonwm_sd, invb_mean, invb_sd)
  colnames(all.data) <- c("id", "wm_core_mean", "wm_core_sd", "nonbrain_mean", "nonbrain_sd", "nonwm_mean", "nonwm_sd", "invb_mean", "invb_sd")
  
# calculate quality control metrics
  
  all.data$snr_1 <- all.data$wm_core_mean / all.data$nonwm_sd
  all.data$snr_2 <- all.data$wm_core_mean / all.data$nonbrain_sd
  all.data$nbcr <- all.data$nonbrain_mean / all.data$wm_core_mean
  all.data$nonbrain_ratio <- all.data$nonbrain_mean / all.data$nonbrain_sd
  all.data$nonwm_to_core <- all.data$nonwm_mean / all.data$wm_core_sd
  all.data$inv_brain_ratio <- all.data$invb_mean / all.data$invb_sd
  
# histograms and boxplots

  # density plots
  
  jpeg('snr1.jpg')
  d_snr1 <- density(all.data$snr_1)
  plot(d_snr1, main="snr1")
  polygon(d_snr1, col="red", border="blue")
  abline(v=2.46)
  dev.off()
  
  jpeg('snr2.jpg')
  d_snr2 <- density(all.data$snr_2)
  plot(d_snr2, main="snr2")
  polygon(d_snr2, col="red", border="blue")
  abline(v=2.17)
  dev.off()
  
  jpeg("nonbr_wm_ratio.jpg")
  d_wm <- density(all.data$nbcr)
  plot(d_wm, main="non-brain to wm ratio")
  polygon(d_wm, col="red", border="blue")
  abline(v=0.47)
  dev.off()
  
  jpeg("nonbr_snr1.jpg")
  d_nonbrain_ratio1 <- density(all.data$nonbrain_ratio)
  plot(d_nonbrain_ratio1, main="non-brain snr1")
  polygon(d_nonbrain_ratio1, col="red", border="blue")
  abline(v=1.18)
  dev.off()
  
  jpeg("nonbr_snr2.jpg")
  d_nonbrain_ratio2 <- density(all.data$nonwm_to_core)
  plot(d_nonbrain_ratio2, main="non-brain snr2")
  polygon(d_nonbrain_ratio2, col="red", border="blue")
  abline(v=1.39)
  dev.off()
  
  jpeg("nonbr_snr3.jpg")
  d_nonbrain_ratio3 <- density(all.data$inv_brain_ratio)
  plot(d_nonbrain_ratio3, main="non-brain snr3")
  polygon(d_nonbrain_ratio3, col="red", border="blue")
  abline(v=1.15)
  dev.off()

# filter outliers for inspection
  
check_imgs <- subset(all.data, snr_1 <= 2.46 | snr_2 <= 2.17 | nbcr >= 0.47 |nonbrain_ratio >= 1.18 | nonwm_to_core >= 1.39 | inv_brain_ratio >= 1.15, select = id)  
  
write.table(check_imgs, file = "check_these_images.csv", row.names = FALSE, na = "",col.names = FALSE, sep = ";", dec = ",")
