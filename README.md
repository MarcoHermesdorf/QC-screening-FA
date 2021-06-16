# Brief quality screening for FA images

* Purpose

This project aims to provide a brief quality screening for fractional anisotropy images, based on several signal to noise ratios. 

* Required software
	- FSL
	- R

* Required data
 	- *FA.nii.gz images

* Included scripts
	- start_qc.sh
	- FA_extract.sh
	- qc.R

* Output
	- check_these_images.csv 
	- several SNR density plots

## Usage

Make start_qc.sh executable and run it. You will need to provide the path to the *FA.nii.gz images.

```bash

chmod +x start_qc.sh

./start_qc.sh

```

If the SNR density plots indicate that the cut-off values for the SNRs do not work well for your data, it may be reasonable to adjust them in the qc.R file. 

Images that should be further inspected are listed in the check_these_images.csv file.

## Referencing this script

If you find this quality screening helpful, please cite the underlying software:

Jenkinson, M., Beckmann, C.F., Behrens, T.E., Woolrich, M.W., Smith, S.M. FSL. NeuroImage, 62:782-90, 2012 

Jenkinson, M., Bannister, P., Brady, J.M. and Smith, S.M. Improved Optimisation for the Robust and Accurate Linear Registration and Motion Correction of Brain Images. NeuroImage, 17(2), 825-841, 2002. 
