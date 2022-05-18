#!/bin/bash

# setup reg

	cd $1
	cp *FA.nii.gz $2/quality_control/reg
	cp /usr/local/fsl/data/atlases/JHU/JHU-ICBM-FA-1mm.nii.gz $2/quality_control/reg

# reg and masks

	cd $2/quality_control/reg

	for img in *FA.nii.gz; do
		echo "${img}" >> id_list.csv;
	done

	for img in *FA.nii.gz; do
		flirt -in ${img} -ref JHU-ICBM-FA-1mm.nii.gz -out ${img%.nii.gz}_reg.nii.gz;
	done

	for img in *FA_reg.nii.gz; do
		echo "${img}" >> qc_list.csv;
	done

	fslmaths JHU-ICBM-FA-1mm.nii.gz -thr 0.2 -bin wm_core

	fslmerge -t qc_sample `cat qc_list.csv`

	fslmaths qc_sample -Tmean -thr 0.1 -bin sample_brain_mask

	fslmaths sample_brain_mask -kernel sphere 10 -fmean -thr 0.1 -bin -sub wm_core -bin non_wm

	fslmaths sample_brain_mask -mul -1 -add 1 sample_brain_mask_inv

	fslmaths non_wm -sub sample_brain_mask -bin non_brain

# get wm_core values

	for img in *FA_reg.nii.gz; do
		echo `fslstats ${img} -k wm_core -S` >> wm_core_std.csv;
		echo `fslstats ${img} -k wm_core -M` >> wm_core_mean.csv;
	done

# get non_brain values

	for img in *FA_reg.nii.gz; do
		echo `fslstats ${img} -k non_brain -S` >> nonbrain_std.csv;
		echo `fslstats ${img} -k non_brain -M` >> nonbrain_mean.csv;
	done

# get proxymal non-brain values

	for img in *FA_reg.nii.gz; do
		echo `fslstats ${img} -k non_wm -S` >> nonwm_std.csv;
		echo `fslstats ${img} -k non_wm -M` >> nonwm_mean.csv;
	done

# get distal non-brain values

	for img in *FA_reg.nii.gz; do
		echo `fslstats ${img} -k sample_brain_mask_inv -M` >> inv_brain_mean.csv;
		echo `fslstats ${img} -k sample_brain_mask_inv -S` >> inv_brain_sd.csv;
	done

# run quality control

	rscript ../../qc.R ${2}/quality_control/reg && mv check_these_images.csv .. && mv *.jpg ..
