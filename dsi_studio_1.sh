#! /bin/bash
#! /bin/bash -e
# dti_studio
# usage:dsi_studio.sh foldername
# This script was made by H.S. Kim
# parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3Ec
# parameter_id=0528033D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3Ec

f=${1}

echo FOLDER IS $f

cd ${f}

pwd

echo CURRENT WORKING DIRECTORY IS $f


echo STEP 1: DCM to nii

/Applications/mricronmac/dcm2nii ${f}

if [ -e ${f}/*.bval ]; then
echo STEP 1:Complete process of dcm2nii
fi

cp ${f}/x*.bval ${f}/b.bval
cp ${f}/x*.bvec ${f}/b.bvec
cp ${f}/2*T1*.nii.gz ${f}/T1.nii.gz
cp ${f}/x*DTI*.nii.gz ${f}/DTI.nii.gz

echo STEP 2: SUSAN NOISE REDUCTION
susan ${f}/x*DTI*.nii.gz 42.1683136 3 3 1 0 ${f}/data
if [ -e ${f}/data.nii.gz ]; then
echo STEP 2:  END of SUSAN NOISE REDUCTION
fi

echo STEP 3: CONVERSION From NIFTI SRC files

/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=src --source=${f}/data.nii.gz --bval=b.bval --bvec=b.bvec --output=brain.src.gz
if [ -e ${f}/brain.src.gz ]; then
echo STEP 3: END OF CONVERSION From NIFTI SRC files
fi

echo STEP 4: IMAGE RECONSTRUCTION
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=rec --source=${f}/brain.src.gz --method=7 --param0=1.25 --other_image=t1w,${f}/T1.nii.gz
if [ -e ${f}/*qsdr*.fib.gz ]; then
echo STEP 4: END of IMAGE RECONSTRUCTION
fi

echo STEP 5: FIBER TRACKING

cp ${f}/*.qsdr.*fib.gz ${f}/qsdr.fib.gz
mkdir JPG_folder
mkdir Statistic_folder

echo Acoustic_Radiation_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=0 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Acoustic_Radiation_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Lt.trk.gz --output=Acoustic_Radiation_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Lt.trk.gz --output=Acoustic_Radiation_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Acoustic_Radiation_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Acoustic_Radiation_Lt.trk.gz3D.jpg+save_h3view_image,hAcoustic_Radiation_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Acoustic_Radiation_Lt
cp *Acoustic_Radiation_Lt* ${f}/Acoustic_Radiation_Lt


if [ -e ${f}/Acoustic_Radiation_Lt.trk.gz ]; then
echo STEP 5-1: Complete of Acoustic_Radiation_Lt
fi

if [ ! -e ${f}/Acoustic_Radiation_Lt.trk.gz ]; then
echo  Acoustic_Radiation_Lt>> loss_track_list.txt
fi

echo Acoustic_Radiation_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=1 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Acoustic_Radiation_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Rt.trk.gz --output=Acoustic_Radiation_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Rt.trk.gz --output=Acoustic_Radiation_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Acoustic_Radiation_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Acoustic_Radiation_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Acoustic_Radiation_Rt.trk.gz3D.jpg+save_h3view_image,hAcoustic_Radiation_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Acoustic_Radiation_Rt
cp *Acoustic_Radiation_Rt* ${f}/Acoustic_Radiation_Rt



if [ -e ${f}/Acoustic_Radiation_Rt.trk.gz ]; then
echo STEP 5-2: Complete of Acoustic_Radiation_Rt
fi

if [ ! -e ${f}/Acoustic_Radiation_Rt.trk.gz ]; then
echo  Acoustic_Radiation_Rt >> loss_track_list.txt
fi

echo Cortico_Striatal_Pathway_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=2 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cortico_Striatal_Pathway_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Lt.trk.gz --output=Cortico_Striatal_Pathway_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Lt.trk.gz --output=Cortico_Striatal_Pathway_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cortico_Striatal_Pathway_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cortico_Striatal_Pathway_Lt.trk.gz3D.jpg+save_h3view_image,hCortico_Striatal_Pathway_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cortico_Striatal_Pathway_Lt
cp *Cortico_Striatal_Pathway_Lt* ${f}/Cortico_Striatal_Pathway_Lt


if [ -e ${f}/Cortico_Striatal_Pathway_Lt.trk.gz ]; then
echo STEP 5-3: Complete of Cortico_Striatal_Pathway_Lt
fi

if [ ! -e ${f}/Cortico_Striatal_Pathway_Lt.trk.gz ]; then
echo  Cortico_Striatal_Pathway_Lt >> loss_track_list.txt
fi

echo Cortico_Striatal_Pathway_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=3 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cortico_Striatal_Pathway_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Rt.trk.gz --output=Cortico_Striatal_Pathway_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Rt.trk.gz --output=Cortico_Striatal_Pathway_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Striatal_Pathway_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cortico_Striatal_Pathway_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cortico_Striatal_Pathway_Rt.trk.gz3D.jpg+save_h3view_image,hCortico_Striatal_Pathway_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cortico_Striatal_Pathway_Rt
cp *Cortico_Striatal_Pathway_Rt* ${f}/Cortico_Striatal_Pathway_Rt

if [ -e ${f}/Cortico_Striatal_Pathway_Rt.trk.gz ]; then
echo STEP 5-4: Complete of Cortico_Striatal_Pathway_Rt
fi

if [ ! -e ${f}/Cortico_Striatal_Pathway_Rt.trk.gz ]; then
echo  Cortico_Striatal_Pathway_Rt >> loss_track_list.txt
fi

echo Cortico_Spinal_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=4 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cortico_Spinal_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Lt.trk.gz --output=Cortico_Spinal_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Lt.trk.gz --output=Cortico_Spinal_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cortico_Spinal_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cortico_Spinal_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hCortico_Spinal_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cortico_Spinal_Tract_Lt
cp *Cortico_Spinal_Tract_Lt* ${f}/Cortico_Spinal_Tract_Lt


if [ -e ${f}/Cortico_Spinal_Tract_Lt.trk.gz ]; then
echo STEP 5-5: Complete of Cortico_Spinal_Tract_Lt
fi

if [ ! -e ${f}/Cortico_Spinal_Tract_Lt.trk.gz ]; then
echo  Cortico_Spinal_Tract_Lt >> loss_track_list.txt
fi

echo Cortico_Spinal_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=5 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cortico_Spinal_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Rt.trk.gz --output=Cortico_Spinal_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Rt.trk.gz --output=Cortico_Spinal_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cortico_Spinal_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cortico_Spinal_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cortico_Spinal_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hCortico_Spinal_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cortico_Spinal_Tract_Rt
cp *Cortico_Spinal_Tract_Rt* ${f}/Cortico_Spinal_Tract_Rt


if [ -e ${f}/Cortico_Spinal_Tract_Rt.trk.gz ]; then
echo STEP 5-6: Complete of Cortico_Spinal_Tract_Rt
fi

if [ ! -e ${f}/Cortico_Spinal_Tract_Rt.trk.gz ]; then
echo  Cortico_Spinal_Tract_Rt >> loss_track_list.txt
fi

echo Corticothalamic_Pathway_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=6 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Corticothalamic_Pathway_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Lt.trk.gz --output=Corticothalamic_Pathway_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Lt.trk.gz --output=Corticothalamic_Pathway_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Corticothalamic_Pathway_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Corticothalamic_Pathway_Lt.trk.gz3D.jpg+save_h3view_image,hCorticothalamic_Pathway_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Corticothalamic_Pathway_Lt
cp *Corticothalamic_Pathway_Lt* ${f}/Corticothalamic_Pathway_Lt


if [ -e ${f}/Corticothalamic_Pathway_Lt.trk.gz ]; then
echo STEP 5-7: Complete of Corticothalamic_Pathway_Lt
fi

if [ ! -e ${f}/Corticothalamic_Pathway_Lt.trk.gz ]; then
echo  Corticothalamic_Pathway_Lt >> loss_track_list.txt
fi

echo Corticothalamic_Pathway_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=7 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Corticothalamic_Pathway_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Rt.trk.gz --output=Corticothalamic_Pathway_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Rt.trk.gz --output=Corticothalamic_Pathway_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corticothalamic_Pathway_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Corticothalamic_Pathway_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Corticothalamic_Pathway_Rt.trk.gz3D.jpg+save_h3view_image,hCorticothalamic_Pathway_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Corticothalamic_Pathway_Rt
cp *Corticothalamic_Pathway_Rt* ${f}/Corticothalamic_Pathway_Rt


if [ -e ${f}/Corticothalamic_Pathway_Rt.trk.gz ]; then
echo STEP 5-8: Complete of Corticothalamic_Pathway_Rt
fi

if [ ! -e ${f}/Corticothalamic_Pathway_Rt.trk.gz ]; then
echo  Corticothalamic_Pathway_Rt >> loss_track_list.txt
fi

echo Fornix_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=8 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Fornix_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Lt.trk.gz --output=Fornix_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Lt.trk.gz --output=Fornix_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Fornix_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Fornix_Lt.trk.gz3D.jpg+save_h3view_image,hFornix_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Fornix_Lt
cp *Fornix_Lt* ${f}/Fornix_Lt


if [ -e ${f}/Fornix_Lt.trk.gz ]; then
echo STEP 5-9: Complete of Fornix_Lt
fi

if [ ! -e ${f}/Fornix_Lt.trk.gz ]; then
echo  Fornix_Lt >> loss_track_list.txt
fi

echo Fornix_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=9 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Fornix_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Rt.trk.gz --output=Fornix_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Rt.trk.gz --output=Fornix_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Fornix_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Fornix_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Fornix_Rt.trk.gz3D.jpg+save_h3view_image,hFornix_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Fornix_Rt
cp *Fornix_Rt* ${f}/Fornix_Rt


if [ -e ${f}/Fornix_Rt.trk.gz ]; then
echo STEP 5-10: Complete of Fornix_Rt
fi

if [ ! -e ${f}/Fornix_Rt.trk.gz ]; then
echo  Fornix_Rt >> loss_track_list.txt
fi

echo Frontopontine_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=10 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Frontopontine_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Lt.trk.gz --output=Frontopontine_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Lt.trk.gz --output=Frontopontine_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Frontopontine_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Frontopontine_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hFrontopontine_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Frontopontine_Tract_Lt
cp *Frontopontine_Tract_Lt* ${f}/Frontopontine_Tract_Lt

if [ -e ${f}/Frontopontine_Tract_Lt.trk.gz ]; then
echo STEP 5-11: Complete of Frontopontine_Tract_Lt
fi

if [ ! -e ${f}/Frontopontine_Tract_Lt.trk.gz ]; then
echo  Frontopontine_Tract_Lt >> loss_track_list.txt
fi

echo Frontopontine_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=11 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Frontopontine_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Rt.trk.gz --output=Frontopontine_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Rt.trk.gz --output=Frontopontine_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontopontine_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Frontopontine_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Frontopontine_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hFrontopontine_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Frontopontine_Tract_Rt
cp *Frontopontine_Tract_Rt* ${f}/Frontopontine_Tract_Rt


if [ -e ${f}/Frontopontine_Tract_Rt.trk.gz ]; then
echo STEP 5-12: Complete of Frontopontine_Tract_Rt
fi

if [ ! -e ${f}/Frontopontine_Tract_Rt.trk.gz ]; then
echo  Frontopontine_Tract_Rt >> loss_track_list.txt
fi

echo Occipitopontine_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=12 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Occipitopontine_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Lt.trk.gz --output=Occipitopontine_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Lt.trk.gz --output=Occipitopontine_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Occipitopontine_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Occipitopontine_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hOccipitopontine_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
cp *Occipitopontine_Tract_Lt* ${f}/Occipitopontine_Tract_Lt
# mkdir Occipitopontine_Tract_Lt

if [ -e ${f}/Occipitopontine_Tract_Lt.trk.gz ]; then
echo STEP 5-13: Complete of Occipitopontine_Tract_Lt
fi

if [ ! -e ${f}/Occipitopontine_Tract_Lt.trk.gz ]; then
echo  Occipitopontine_Tract_Lt >> loss_track_list.txt
fi

echo Occipitopontine_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=13 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Occipitopontine_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Rt.trk.gz --output=Occipitopontine_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Rt.trk.gz --output=Occipitopontine_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Occipitopontine_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Occipitopontine_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Occipitopontine_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hOccipitopontine_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Occipitopontine_Tract_Rt
cp *Occipitopontine_Tract_Rt* ${f}/Occipitopontine_Tract_Rt


if [ -e ${f}/Occipitopontine_Tract_Rt.trk.gz ]; then
echo STEP 5-14: Complete of Occipitopontine_Tract_Rt
fi

if [ ! -e ${f}/Occipitopontine_Tract_Rt.trk.gz ]; then
echo  Occipitopontine_Tract_Rt >> loss_track_list.txt
fi

echo Optic_Radiation_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=14 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Optic_Radiation_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Lt.trk.gz --output=Optic_Radiation_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Lt.trk.gz --output=Optic_Radiation_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Optic_Radiation_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Optic_Radiation_Lt.trk.gz3D.jpg+save_h3view_image,hOptic_Radiation_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Optic_Radiation_Lt
cp *Optic_Radiation_Lt* ${f}/Optic_Radiation_Lt


if [ -e ${f}/Optic_Radiation_Lt.trk.gz ]; then
echo STEP 5-15: Complete of  Optic_Radiation_Lt
fi

if [ ! -e ${f}/Optic_Radiation_Lt.trk.gz ]; then
echo  Optic_Radiation_Lt >> loss_track_list.txt
fi

echo Optic_Radiation_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=15 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Optic_Radiation_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Rt.trk.gz --output=Optic_Radiation_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Rt.trk.gz --output=Optic_Radiation_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Optic_Radiation_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Optic_Radiation_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Optic_Radiation_Rt.trk.gz3D.jpg+save_h3view_image,hOptic_Radiation_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Optic_Radiation_Rt
cp *Optic_Radiation_Rt* ${f}/Optic_Radiation_Rt

if [ -e ${f}/Optic_Radiation_Rt.trk.gz ]; then
echo STEP 5-16: Complete of Optic_Radiation_Rt
fi

if [ ! -e ${f}/Optic_Radiation_Rt.trk.gz ]; then
echo  Optic_Radiation_Rt >> loss_track_list.txt
fi

echo Parietopontine_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=16 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Parietopontine_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Lt.trk.gz --output=Parietopontine_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Lt.trk.gz --output=Parietopontine_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Parietopontine_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Parietopontine_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hParietopontine_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Parietopontine_Tract_Lt
cp *Parietopontine_Tract_Lt* ${f}/Parietopontine_Tract_Lt


if [ -e ${f}/Parietopontine_Tract_Lt.trk.gz ]; then
echo STEP 5-17: Complete of  Parietopontine_Tract_Lt
fi

if [ ! -e ${f}/Parietopontine_Tract_Lt.trk.gz ]; then
echo  Parietopontine_Tract_Lt >> loss_track_list.txt
fi

echo Parietopontine_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=17 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Parietopontine_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Rt.trk.gz --output=Parietopontine_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Rt.trk.gz --output=Parietopontine_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Parietopontine_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Parietopontine_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Parietopontine_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hParietopontine_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Parietopontine_Tract_Rt
cp *Parietopontine_Tract_Rt* ${f}/Parietopontine_Tract_Rt


if [ -e ${f}/Parietopontine_Tract_Rt.trk.gz ]; then
echo STEP 5-18: Complete of  Parietopontine_Tract_Rt
fi

if [ ! -e ${f}/Parietopontine_Tract_Rt.trk.gz ]; then
echo  Parietopontine_Tract_Rt >> loss_track_list.txt
fi

echo Temporopontine_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=18 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Temporopontine_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Lt.trk.gz --output=Temporopontine_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Lt.trk.gz --output=Temporopontine_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Temporopontine_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Temporopontine_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hTemporopontine_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Temporopontine_Tract_Lt
cp *Temporopontine_Tract_Lt* ${f}/Temporopontine_Tract_Lt


if [ -e ${f}/Temporopontine_Tract_Lt.trk.gz ]; then
echo STEP 5-19: Complete of Temporopontine_Tract_Lt
fi

if [ ! -e ${f}/Temporopontine_Tract_Lt.trk.gz ]; then
echo  Temporopontine_Tract_Lt >> loss_track_list.txt
fi

echo Temporopontine_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=19 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Temporopontine_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Rt.trk.gz --output=Temporopontine_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Rt.trk.gz --output=Temporopontine_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Temporopontine_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Temporopontine_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Temporopontine_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hTemporopontine_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Temporopontine_Tract_Rt
cp *Temporopontine_Tract_Rt* ${f}/Temporopontine_Tract_Rt


if [ -e ${f}/Temporopontine_Tract_Rt.trk.gz ]; then
echo STEP 5-20: Complete of Temporopontine_Tract_Rt
fi

if [ ! -e ${f}/Temporopontine_Tract_Rt.trk.gz ]; then
echo  Temporopontine_Tract_Rt >> loss_track_list.txt
fi

echo Arcuate_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=20 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Arcuate_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Lt.trk.gz --output=Arcuate_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Lt.trk.gz --output=Arcuate_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Arcuate_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Arcuate_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hArcuate_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Arcuate_Fasciculus_Lt
cp *Arcuate_Fasciculus_Lt* ${f}/Arcuate_Fasciculus_Lt


if [ -e ${f}/Arcuate_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-21: Complete of Arcuate_Fasciculus_Lt
fi

if [ ! -e ${f}/Arcuate_Fasciculus_Lt.trk.gz ]; then
echo  Arcuate_Fasciculus_Lt>> loss_track_list.txt
fi

echo Arcuate_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=21 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Arcuate_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Rt.trk.gz --output=Arcuate_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Rt.trk.gz --output=Arcuate_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Arcuate_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Arcuate_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Arcuate_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hArcuate_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Arcuate_Fasciculus_Rt
cp *Arcuate_Fasciculus_Rt* ${f}/Arcuate_Fasciculus_Rt


if [ -e ${f}/Arcuate_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-22: Complete of Arcuate_Fasciculus_Rt
fi

if [ ! -e ${f}/Arcuate_Fasciculus_Rt.trk.gz ]; then
echo  Arcuate_Fasciculus_Rt>> loss_track_list.txt
fi

echo Cingulum_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=22 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cingulum_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Lt.trk.gz --output=Cingulum_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Lt.trk.gz --output=Cingulum_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cingulum_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cingulum_Lt.trk.gz3D.jpg+save_h3view_image,hCingulum_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cingulum_Lt
cp *Cingulum_Lt* ${f}/Cingulum_Lt

if [ -e ${f}/Cingulum_Lt.trk.gz ]; then
echo STEP 5-23: Complete of Cingulum_Lt
fi

if [ ! -e ${f}/Cingulum_Lt.trk.gz ]; then
echo  Cingulum_Lt >> loss_track_list.txt
fi

echo Cingulum_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=23 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cingulum_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Rt.trk.gz --output=Cingulum_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Rt.trk.gz --output=Cingulum_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cingulum_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cingulum_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cingulum_Rt.trk.gz3D.jpg+save_h3view_image,hCingulum_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cingulum_Rt
cp *Cingulum_Rt* ${f}/Cingulum_Rt


if [ -e ${f}/Cingulum_Rt.trk.gz ]; then
echo STEP 5-24: Complete of Cingulum_Rt
fi

if [ ! -e ${f}/Cingulum_Rt.trk.gz ]; then
echo  Cingulum_Rt >> loss_track_list.txt
fi

echo Extreme_Capsule_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=24 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Extreme_Capsule_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Lt.trk.gz --output=Extreme_Capsule_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Lt.trk.gz --output=Extreme_Capsule_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Extreme_Capsule_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Extreme_Capsule_Lt.trk.gz3D.jpg+save_h3view_image,hExtreme_Capsule_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Extreme_Capsule_Lt
cp *Extreme_Capsule_Lt* ${f}/Extreme_Capsule_Lt

if [ -e ${f}/Extreme_Capsule_Lt.trk.gz ]; then
echo STEP 5-25: Complete of Extreme_Capsule_Lt
fi

if [ ! -e ${f}/Extreme_Capsule_Lt.trk.gz ]; then
echo  Extreme_Capsule_Lt >> loss_track_list.txt
fi

echo Extreme_Capsule_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=25 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Extreme_Capsule_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Rt.trk.gz --output=Extreme_Capsule_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Rt.trk.gz --output=Extreme_Capsule_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Extreme_Capsule_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Extreme_Capsule_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Extreme_Capsule_Rt.trk.gz3D.jpg+save_h3view_image,hExtreme_Capsule_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Extreme_Capsule_Rt
cp *Extreme_Capsule_Rt* ${f}/Extreme_Capsule_Rt


if [ -e ${f}/Extreme_Capsule_Rt.trk.gz ]; then
echo STEP 5-26: Complete of Extreme_Capsule_Rt
fi

if [ ! -e ${f}/Extreme_Capsule_Rt.trk.gz ]; then
echo  Extreme_Capsule_Rt >> loss_track_list.txt
fi

echo Frontal_Aslant_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=26 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Frontal_Aslant_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Lt.trk.gz --output=Frontal_Aslant_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Lt.trk.gz --output=Frontal_Aslant_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Frontal_Aslant_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Frontal_Aslant_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hFrontal_Aslant_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Frontal_Aslant_Tract_Lt
cp *Frontal_Aslant_Tract_Lt* ${f}/Frontal_Aslant_Tract_Lt


if [ -e ${f}/Frontal_Aslant_Tract_Lt.trk.gz ]; then
echo STEP 5-27: Complete of Frontal_Aslant_Tract_Lt
fi

if [ ! -e ${f}/Frontal_Aslant_Tract_Lt.trk.gz ]; then
echo  Frontal_Aslant_Tract_Lt >> loss_track_list.txt
fi

echo Frontal_Aslant_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=27 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Frontal_Aslant_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Rt.trk.gz --output=Frontal_Aslant_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Rt.trk.gz --output=Frontal_Aslant_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Frontal_Aslant_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Frontal_Aslant_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Frontal_Aslant_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hFrontal_Aslant_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Frontal_Aslant_Tract_Rt
cp *Frontal_Aslant_Tract_Rt* ${f}/Frontal_Aslant_Tract_Rt


if [ -e ${f}/Frontal_Aslant_Tract_Rt.trk.gz ]; then
echo STEP 5-28: Complete of Frontal_Aslant_Tract_Rt
fi

if [ ! -e ${f}/Frontal_Aslant_Tract_Rt.trk.gz ]; then
echo  Frontal_Aslant_Tract_Rt >> loss_track_list.txt
fi

echo Inferior_Fronto_Occipital_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=28 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz --output=Inferior_Fronto_Occipital_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz --output=Inferior_Fronto_Occipital_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hInferior_Fronto_Occipital_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Fronto_Occipital_Fasciculus_Lt
cp *Inferior_Fronto_Occipital_Fasciculus_Lt* ${f}/Inferior_Fronto_Occipital_Fasciculus_Lt


if [ -e ${f}/Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-29: Complete of Inferior_Fronto_Occipital_Fasciculus_Lt
fi

if [ ! -e ${f}/Inferior_Fronto_Occipital_Fasciculus_Lt.trk.gz ]; then
Inferior_Fronto_Occipital_Fasciculus_Lt echo  Inferior_Fronto_Occipital_Fasciculus_Lt >> loss_track_list.txt
fi

echo Inferior_Fronto_Occipital_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=29 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz --output=Inferior_Fronto_Occipital_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz --output=Inferior_Fronto_Occipital_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Fronto_Occipital_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hInferior_Fronto_Occipital_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Fronto_Occipital_Fasciculus_Rt
cp *Inferior_Fronto_Occipital_Fasciculus_Rt* ${f}/Inferior_Fronto_Occipital_Fasciculus_Rt


if [ -e ${f}/Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-30: Complete of Inferior_Fronto_Occipital_Fasciculus_Rt
fi

if [ ! -e ${f}/Inferior_Fronto_Occipital_Fasciculus_Rt.trk.gz ]; then
echo  Inferior_Fronto_Occipital_Fasciculus_Rt >> loss_track_list.txt
fi

echo Inferior_Longitudinal_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=30 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Longitudinal_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Lt.trk.gz --output=Inferior_Longitudinal_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Lt.trk.gz --output=Inferior_Longitudinal_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Longitudinal_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hInferior_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Longitudinal_Fasciculus_Lt
cp *Inferior_Longitudinal_Fasciculus_Lt* ${f}/Inferior_Longitudinal_Fasciculus_Lt

if [ -e ${f}/Inferior_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-31: Complete of Inferior_Longitudinal_Fasciculus_Lt
fi

if [ ! -e ${f}/Inferior_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo  Inferior_Longitudinal_Fasciculus_Lt >> loss_track_list.txt
fi

echo Inferior_Longitudinal_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=31 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Longitudinal_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Rt.trk.gz --output=Inferior_Longitudinal_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Rt.trk.gz --output=Inferior_Longitudinal_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Longitudinal_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Longitudinal_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hInferior_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Longitudinal_Fasciculus_Rt
cp *Inferior_Longitudinal_Fasciculus_Rt* ${f}/Inferior_Longitudinal_Fasciculus_Rt


if [ -e ${f}/Inferior_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-32: Complete of Inferior_Longitudinal_Fasciculus_Rt
fi

if [ ! -e ${f}/Inferior_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo  Inferior_Longitudinal_Fasciculus_Rt >> loss_track_list.txt
fi

echo Middle_Longitudinal_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=32 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Middle_Longitudinal_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Lt.trk.gz --output=Middle_Longitudinal_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Lt.trk.gz --output=Middle_Longitudinal_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Middle_Longitudinal_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Middle_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hMiddle_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Middle_Longitudinal_Fasciculus_Lt
cp *Middle_Longitudinal_Fasciculus_Lt* ${f}/Middle_Longitudinal_Fasciculus_Lt

if [ -e ${f}/Middle_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-33: Complete of Middle_Longitudinal_Fasciculus_Lt
fi

if [ ! -e ${f}/Middle_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo  Middle_Longitudinal_Fasciculus_Lt >> loss_track_list.txt
fi

echo Middle_Longitudinal_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=33 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Middle_Longitudinal_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Rt.trk.gz --output=Middle_Longitudinal_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Rt.trk.gz --output=Middle_Longitudinal_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Longitudinal_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Middle_Longitudinal_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Middle_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hMiddle_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Middle_Longitudinal_Fasciculus_Rt
cp *Middle_Longitudinal_Fasciculus_Rt* ${f}/Middle_Longitudinal_Fasciculus_Rt


if [ -e ${f}/Middle_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-34: Complete of Middle_Longitudinal_Fasciculus_Rt
fi

if [ ! -e ${f}/Middle_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo  Middle_Longitudinal_Fasciculus_Rt >> loss_track_list.txt
fi

echo Superior_Longitudinal_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=34 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Superior_Longitudinal_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Lt.trk.gz --output=Superior_Longitudinal_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Lt.trk.gz --output=Superior_Longitudinal_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Superior_Longitudinal_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Superior_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hSuperior_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Superior_Longitudinal_Fasciculus_Lt
cp *Superior_Longitudinal_Fasciculus_Lt* ${f}/Superior_Longitudinal_Fasciculus_Lt


if [ -e ${f}/Superior_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-35: Complete of Superior_Longitudinal_Fasciculus_Lt
fi

if [ ! -e ${f}/Superior_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo  Superior_Longitudinal_Fasciculus_Lt >> loss_track_list.txt
fi

echo Superior_Longitudinal_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=35 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Superior_Longitudinal_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Rt.trk.gz --output=Superior_Longitudinal_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Rt.trk.gz --output=Superior_Longitudinal_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Longitudinal_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Superior_Longitudinal_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Superior_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hSuperior_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Superior_Longitudinal_Fasciculus_Rt
cp *Superior_Longitudinal_Fasciculus_Rt* ${f}/Superior_Longitudinal_Fasciculus_Rt


if [ -e ${f}/Superior_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-36: Complete of Superior_Longitudinal_Fasciculus_Rt
fi

if [ ! -e ${f}/Superior_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo  Superior_Longitudinal_Fasciculus_Rt >> loss_track_list.txt
fi

echo U_Fiber_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=36 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/U_Fiber_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Lt.trk.gz --output=U_Fiber_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Lt.trk.gz --output=U_Fiber_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=U_Fiber_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,U_Fiber_Lt.trk.gz3D.jpg+save_h3view_image,hU_Fiber_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
cp *U_Fiber_Lt* ${f}/U_Fiber_Lt
# mkdir U_Fiber_Lt

if [ -e ${f}/U_Fiber_Lt.trk.gz ]; then
echo STEP 5-37: Complete of U_Fiber_Lt
fi

if [ ! -e ${f}/U_Fiber_Lt.trk.gz ]; then
echo  U_Fiber_Lt >> loss_track_list.txt
fi

echo U_Fiber_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=37 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/U_Fiber_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Rt.trk.gz --output=U_Fiber_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Rt.trk.gz --output=U_Fiber_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=U_Fiber_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=U_Fiber_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,U_Fiber_Rt.trk.gz3D.jpg+save_h3view_image,hU_Fiber_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir U_Fiber_Rt
cp *U_Fiber_Rt* ${f}/U_Fiber_Rt


if [ -e ${f}/U_Fiber_Rt.trk.gz ]; then
echo STEP 5-38: Complete of U_Fiber_Rt
fi

if [ ! -e ${f}/U_Fiber_Rt.trk.gz ]; then
echo  U_Fiber_Rt >> loss_track_list.txt
fi

echo Uncinate_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=38 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Uncinate_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Lt.trk.gz --output=Uncinate_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Lt.trk.gz --output=Uncinate_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Uncinate_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Uncinate_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hUncinate_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Uncinate_Fasciculus_Lt
cp *Uncinate_Fasciculus_Lt* ${f}/Uncinate_Fasciculus_Lt


if [ -e ${f}/Uncinate_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-39: Complete of Uncinate_Fasciculus_Lt
fi

if [ ! -e ${f}/Uncinate_Fasciculus_Lt.trk.gz ]; then
echo  Uncinate_Fasciculus_Lt >> loss_track_list.txt
fi

echo Uncinate_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=39 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Uncinate_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Rt.trk.gz --output=Uncinate_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Rt.trk.gz --output=Uncinate_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Uncinate_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Uncinate_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Uncinate_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hUncinate_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Uncinate_Fasciculus_Rt
cp *Uncinate_Fasciculus_Rt* ${f}/Uncinate_Fasciculus_Rt


if [ -e ${f}/Uncinate_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-40: Complete of Uncinate_Fasciculus_Rt
fi

if [ ! -e ${f}/Uncinate_Fasciculus_Rt.trk.gz ]; then
echo  Uncinate_Fasciculus_Rt >> loss_track_list.txt
fi

echo Vertical_Occipital_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=40 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Vertical_Occipital_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Lt.trk.gz --output=Vertical_Occipital_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Lt.trk.gz --output=Vertical_Occipital_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Vertical_Occipital_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Vertical_Occipital_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hVertical_Occipital_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Vertical_Occipital_Fasciculus_Lt
cp *Vertical_Occipital_Fasciculus_Lt* ${f}/Vertical_Occipital_Fasciculus_Lt


if [ -e ${f}/Vertical_Occipital_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-41: Complete of Vertical_Occipital_Fasciculus_Lt
fi

if [ ! -e ${f}/Vertical_Occipital_Fasciculus_Lt.trk.gz ]; then
echo  Vertical_Occipital_Fasciculus_Lt >> loss_track_list.txt
fi

echo Vertical_Occipital_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=41 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Vertical_Occipital_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Rt.trk.gz --output=Vertical_Occipital_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Rt.trk.gz --output=Vertical_Occipital_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vertical_Occipital_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Vertical_Occipital_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Vertical_Occipital_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hVertical_Occipital_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Vertical_Occipital_Fasciculus_Rt
cp *Vertical_Occipital_Fasciculus_Rt* ${f}/Vertical_Occipital_Fasciculus_Rt


if [ -e ${f}/Vertical_Occipital_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-42: Complete of Vertical_Occipital_Fasciculus_Rt
fi

if [ ! -e ${f}/Vertical_Occipital_Fasciculus_Rt.trk.gz ]; then
echo  Vertical_Occipital_Fasciculus_Rt >> loss_track_list.txt
fi

echo Anterior_Commissure
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=42 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Anterior_Commissure.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Anterior_Commissure.trk.gz --output=Anterior_Commissure.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Anterior_Commissure.trk.gz --output=Anterior_Commissure_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Anterior_Commissure.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Anterior_Commissure.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Anterior_Commissure.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Anterior_Commissure.trk.gz3D.jpg+save_h3view_image,hAnterior_Commissure.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Anterior_Commissure
cp *Anterior_Commissure* ${f}/Anterior_Commissure


if [ -e ${f}/Anterior_Commissure.trk.gz ]; then
echo STEP 5-43: Complete of Anterior_Commissure
fi

if [ ! -e ${f}/Anterior_Commissure.trk.gz ]; then
echo  Anterior_Commissure >> loss_track_list.txt
fi

echo Corpus_Callosum
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=43 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Corpus_Callosum.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corpus_Callosum.trk.gz --output=Corpus_Callosum.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corpus_Callosum.trk.gz --output=Corpus_Callosum_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corpus_Callosum.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Corpus_Callosum.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Corpus_Callosum.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Corpus_Callosum.trk.gz3D.jpg+save_h3view_image,hCorpus_Callosum.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Corpus_Callosum
cp *Corpus_Callosum* ${f}/Corpus_Callosum

if [ -e ${f}/Corpus_Callosum.trk.gz ]; then
echo STEP 5-44: Complete of Corpus_Callosum
fi

if [ ! -e ${f}/Corpus_Callosum.trk.gz ]; then
echo  Corpus_Callosum >> loss_track_list.txt
fi

echo Posterior_Commissure
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=44 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Posterior_Commissure .trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Posterior_Commissure .trk.gz --output=Posterior_Commissure .txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Posterior_Commissure .trk.gz --output=Posterior_Commissure _ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Posterior_Commissure .txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Posterior_Commissure .txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Posterior_Commissure .trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Posterior_Commissure .trk.gz3D.jpg+save_h3view_image,hPosterior_Commissure .trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Posterior_Commissure
cp *Posterior_Commissure * ${f}/Posterior_Commissure


if [ -e ${f}/Posterior_Commissure .trk.gz ]; then
echo STEP 5-45: Complete of Posterior_Commissure
fi

if [ ! -e ${f}/Posterior_Commissure .trk.gz ]; then
echo  Posterior_Commissure  >> loss_track_list.txt
fi

echo Cerebellum_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=45 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cerebellum_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Lt.trk.gz --output=Cerebellum_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Lt.trk.gz --output=Cerebellum_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cerebellum_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cerebellum_Lt.trk.gz3D.jpg+save_h3view_image,hCerebellum_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cerebellum_Lt
cp *Cerebellum_Lt* ${f}/Cerebellum_Lt

if [ -e ${f}/Cerebellum_Lt.trk.gz ]; then
echo STEP 5-46: Complete of Cerebellum_Lt
fi

if [ ! -e ${f}/Cerebellum_Lt.trk.gz ]; then
echo  Cerebellum_Lt >> loss_track_list.txt
fi

echo Cerebellum_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=46 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Cerebellum_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Rt.trk.gz --output=Cerebellum_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Rt.trk.gz --output=Cerebellum_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Cerebellum_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Cerebellum_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Cerebellum_Rt.trk.gz3D.jpg+save_h3view_image,hCerebellum_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Cerebellum_Rt
cp *Cerebellum_Rt* ${f}/Cerebellum_Rt


if [ -e ${f}/Cerebellum_Rt.trk.gz ]; then
echo STEP 5-47: Complete of Cerebellum_Rt
fi

if [ ! -e ${f}/Cerebellum_Rt.trk.gz ]; then
echo  Cerebellum_Rt >> loss_track_list.txt
fi

echo Inferior_Cerebellar_Peduncle_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=47 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Cerebellar_Peduncle_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Lt.trk.gz --output=Inferior_Cerebellar_Peduncle_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Lt.trk.gz --output=Inferior_Cerebellar_Peduncle_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Cerebellar_Peduncle_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Cerebellar_Peduncle_Lt.trk.gz3D.jpg+save_h3view_image,hInferior_Cerebellar_Peduncle_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Cerebellar_Peduncle_Lt
cp *Inferior_Cerebellar_Peduncle_Lt* ${f}/Inferior_Cerebellar_Peduncle_Lt


if [ -e ${f}/Inferior_Cerebellar_Peduncle_Lt.trk.gz ]; then
echo STEP 5-48: Complete of Inferior_Cerebellar_Peduncle_Lt
fi

if [ ! -e ${f}/Inferior_Cerebellar_Peduncle_Lt.trk.gz ]; then
echo  Inferior_Cerebellar_Peduncle_Lt >> loss_track_list.txt
fi

echo Inferior_Cerebellar_Peduncle_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=48 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Inferior_Cerebellar_Peduncle_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Rt.trk.gz --output=Inferior_Cerebellar_Peduncle_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Rt.trk.gz --output=Inferior_Cerebellar_Peduncle_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Inferior_Cerebellar_Peduncle_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Inferior_Cerebellar_Peduncle_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Inferior_Cerebellar_Peduncle_Rt.trk.gz3D.jpg+save_h3view_image,hInferior_Cerebellar_Peduncle_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Inferior_Cerebellar_Peduncle_Rt
cp *Inferior_Cerebellar_Peduncle_Rt* ${f}/Inferior_Cerebellar_Peduncle_Rt


if [ -e ${f}/Inferior_Cerebellar_Peduncle_Rt.trk.gz ]; then
echo STEP 5-49: Complete of Inferior_Cerebellar_Peduncle_Rt
fi

if [ ! -e ${f}/Inferior_Cerebellar_Peduncle_Rt.trk.gz ]; then
echo  Inferior_Cerebellar_Peduncle_Rt >> loss_track_list.txt
fi

echo Middle_Cerebellar_Peduncle
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=49 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Middle_Cerebellar_Peduncle.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Cerebellar_Peduncle.trk.gz --output=Middle_Cerebellar_Peduncle.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Cerebellar_Peduncle.trk.gz --output=Middle_Cerebellar_Peduncle_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Cerebellar_Peduncle.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Middle_Cerebellar_Peduncle.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Middle_Cerebellar_Peduncle.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Middle_Cerebellar_Peduncle.trk.gz3D.jpg+save_h3view_image,hMiddle_Cerebellar_Peduncle.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Middle_Cerebellar_Peduncle
cp *Middle_Cerebellar_Peduncle* ${f}/Middle_Cerebellar_Peduncle

if [ -e ${f}/Middle_Cerebellar_Peduncle.trk.gz ]; then
echo STEP 5-50: Complete of Middle_Cerebellar_Peduncle
fi

if [ ! -e ${f}/Middle_Cerebellar_Peduncle.trk.gz ]; then
echo  Middle_Cerebellar_Peduncle >> loss_track_list.txt
fi

echo Superior_Cerebellar_Peduncle
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=50 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Superior_Cerebellar_Peduncle.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Cerebellar_Peduncle.trk.gz --output=Superior_Cerebellar_Peduncle.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Cerebellar_Peduncle.trk.gz --output=Superior_Cerebellar_Peduncle_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Cerebellar_Peduncle.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Superior_Cerebellar_Peduncle.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Superior_Cerebellar_Peduncle.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Superior_Cerebellar_Peduncle.trk.gz3D.jpg+save_h3view_image,hSuperior_Cerebellar_Peduncle.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Superior_Cerebellar_Peduncle
cp *Superior_Cerebellar_Peduncle* ${f}/Superior_Cerebellar_Peduncle


if [ -e ${f}/Superior_Cerebellar_Peduncle.trk.gz ]; then
echo STEP 5-51: Complete of Superior_Cerebellar_Peduncle
fi

if [ ! -e ${f}/Superior_Cerebellar_Peduncle.trk.gz ]; then
echo  Superior_Cerebellar_Peduncle >> loss_track_list.txt
fi

echo Vermis
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=51 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Vermis.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vermis.trk.gz --output=Vermis.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vermis.trk.gz --output=Vermis_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vermis.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Vermis.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Vermis.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Vermis.trk.gz3D.jpg+save_h3view_image,hVermis.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Vermis
cp *Vermis* ${f}/Vermis


if [ -e ${f}/Vermis.trk.gz ]; then
echo STEP 5-52: Complete of Vermis
fi

if [ ! -e ${f}/Vermis.trk.gz ]; then
echo  Vermis >> loss_track_list.txt
fi

echo Central_Tegmental_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=52 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Central_Tegmental_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Lt.trk.gz --output=Central_Tegmental_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Lt.trk.gz --output=Central_Tegmental_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Central_Tegmental_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Central_Tegmental_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hCentral_Tegmental_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Central_Tegmental_Tract_Lt
cp *Central_Tegmental_Tract_Lt* ${f}/Central_Tegmental_Tract_Lt

if [ -e ${f}/Central_Tegmental_Tract_Lt.trk.gz ]; then
echo STEP 5-53: Complete of Central_Tegmental_Tract_Lt
fi

if [ ! -e ${f}/Central_Tegmental_Tract_Lt.trk.gz ]; then
echo  Central_Tegmental_Tract_Lt >> loss_track_list.txt
fi

echo Central_Tegmental_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=53 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Central_Tegmental_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Rt.trk.gz --output=Central_Tegmental_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Rt.trk.gz --output=Central_Tegmental_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Central_Tegmental_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Central_Tegmental_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Central_Tegmental_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hCentral_Tegmental_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Central_Tegmental_Tract_Rt
cp *Central_Tegmental_Tract_Rt* ${f}/Central_Tegmental_Tract_Rt


if [ -e ${f}/Central_Tegmental_Tract_Rt.trk.gz ]; then
echo STEP 5-54: Complete of Central_Tegmental_Tract_Rt
fi

if [ ! -e ${f}/Central_Tegmental_Tract_Rt.trk.gz ]; then
echo  Central_Tegmental_Tract_Rt >> loss_track_list.txt
fi

echo Dorsal_Longitudinal_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=54 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Dorsal_Longitudinal_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Lt.trk.gz --output=Dorsal_Longitudinal_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Lt.trk.gz --output=Dorsal_Longitudinal_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Dorsal_Longitudinal_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Dorsal_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hDorsal_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Dorsal_Longitudinal_Fasciculus_Lt
cp *Dorsal_Longitudinal_Fasciculus_Lt* ${f}/Dorsal_Longitudinal_Fasciculus_Lt


if [ -e ${f}/Dorsal_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-55: Complete of Dorsal_Longitudinal_Fasciculus_Lt
fi

if [ ! -e ${f}/Dorsal_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo  Dorsal_Longitudinal_Fasciculus_Lt >> loss_track_list.txt
fi

echo Dorsal_Longitudinal_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=55 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Dorsal_Longitudinal_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Rt.trk.gz --output=Dorsal_Longitudinal_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Rt.trk.gz --output=Dorsal_Longitudinal_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Dorsal_Longitudinal_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Dorsal_Longitudinal_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Dorsal_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hDorsal_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Dorsal_Longitudinal_Fasciculus_Rt
cp *Dorsal_Longitudinal_Fasciculus_Rt* ${f}/Dorsal_Longitudinal_Fasciculus_Rt


if [ -e ${f}/Dorsal_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-56: Complete of Dorsal_Longitudinal_Fasciculus_Rt
fi

if [ ! -e ${f}/Dorsal_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo  Dorsal_Longitudinal_Fasciculus_Rt >> loss_track_list.txt
fi

echo Lateral_Lemniscus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=56 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Lateral_Lemniscus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Lt.trk.gz --output=Lateral_Lemniscus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Lt.trk.gz --output=Lateral_Lemniscus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Lateral_Lemniscus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Lateral_Lemniscus_Lt.trk.gz3D.jpg+save_h3view_image,hLateral_Lemniscus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Lateral_Lemniscus_Lt
cp *Lateral_Lemniscus_Lt* ${f}/Lateral_Lemniscus_Lt


if [ -e ${f}/Lateral_Lemniscus_Lt.trk.gz ]; then
echo STEP 5-57: Complete of Lateral_Lemniscus_Lt
fi

if [ ! -e ${f}/Lateral_Lemniscus_Lt.trk.gz ]; then
echo  Lateral_Lemniscus_Lt >> loss_track_list.txt
fi

echo Lateral_Lemniscus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=57 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Lateral_Lemniscus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Rt.trk.gz --output=Lateral_Lemniscus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Rt.trk.gz --output=Lateral_Lemniscus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Lateral_Lemniscus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Lateral_Lemniscus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Lateral_Lemniscus_Rt.trk.gz3D.jpg+save_h3view_image,hLateral_Lemniscus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Lateral_Lemniscus_Rt
cp *Lateral_Lemniscus_Rt* ${f}/Lateral_Lemniscus_Rt


if [ -e ${f}/Lateral_Lemniscus_Rt.trk.gz ]; then
echo STEP 5-58: Complete of Lateral_Lemniscus_Rt
fi

if [ ! -e ${f}/Lateral_Lemniscus_Rt.trk.gz ]; then
echo  Lateral_Lemniscus_Rt >> loss_track_list.txt
fi


echo Medial_Lemniscus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=58 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Medial_Lemniscus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Lt.trk.gz --output=Medial_Lemniscus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Lt.trk.gz --output=Medial_Lemniscus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Medial_Lemniscus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Medial_Lemniscus_Lt.trk.gz3D.jpg+save_h3view_image,hMedial_Lemniscus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Medial_Lemniscus_Lt
cp *Medial_Lemniscus_Lt* ${f}/Medial_Lemniscus_Lt


if [ -e ${f}/Medial_Lemniscus_Lt.trk.gz ]; then
echo STEP 5-59: Complete of Medial_Lemniscus_Lt
fi

if [ ! -e ${f}/Medial_Lemniscus_Lt.trk.gz ]; then
echo  Medial_Lemniscus_Lt >> loss_track_list.txt
fi

echo Medial_Lemniscus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=59 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Medial_Lemniscus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Rt.trk.gz --output=Medial_Lemniscus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Rt.trk.gz --output=Medial_Lemniscus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Lemniscus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Medial_Lemniscus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Medial_Lemniscus_Rt.trk.gz3D.jpg+save_h3view_image,hMedial_Lemniscus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
# mkdir Medial_Lemniscus_Rt
cp *Medial_Lemniscus_Rt* ${f}/Medial_Lemniscus_Rt


if [ -e ${f}/Medial_Lemniscus_Rt.trk.gz ]; then
echo STEP 5-60: Complete of Medial_Lemniscus_Rt
fi

if [ ! -e ${f}/Medial_Lemniscus_Rt.trk.gz ]; then
echo  Medial_Lemniscus_Rt >> loss_track_list.txt
fi

echo Medial_Longitudinal_Fasciculus_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=60 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Medial_Longitudinal_Fasciculus_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Lt.trk.gz --output=Medial_Longitudinal_Fasciculus_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Lt.trk.gz --output=Medial_Longitudinal_Fasciculus_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Medial_Longitudinal_Fasciculus_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Medial_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg+save_h3view_image,hMedial_Longitudinal_Fasciculus_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Medial_Longitudinal_Fasciculus_Lt
cp *Medial_Longitudinal_Fasciculus_Lt* ${f}/Medial_Longitudinal_Fasciculus_Lt

if [ -e ${f}/Medial_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo STEP 5-61: Complete of Medial_Longitudinal_Fasciculus_Lt
fi

if [ ! -e ${f}/Medial_Longitudinal_Fasciculus_Lt.trk.gz ]; then
echo  Medial_Longitudinal_Fasciculus_Lt >> loss_track_list.txt
fi

echo Medial_Longitudinal_Fasciculus_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=61 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Medial_Longitudinal_Fasciculus_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Rt.trk.gz --output=Medial_Longitudinal_Fasciculus_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Rt.trk.gz --output=Medial_Longitudinal_Fasciculus_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Medial_Longitudinal_Fasciculus_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Medial_Longitudinal_Fasciculus_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Medial_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg+save_h3view_image,hMedial_Longitudinal_Fasciculus_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Medial_Longitudinal_Fasciculus_Rt
cp *Medial_Longitudinal_Fasciculus_Rt* ${f}/Medial_Longitudinal_Fasciculus_Rt

if [ -e ${f}/Medial_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo STEP 5-62: Complete of Medial_Longitudinal_Fasciculus_Rt
fi

if [ ! -e ${f}/Medial_Longitudinal_Fasciculus_Rt.trk.gz ]; then
echo  Medial_Longitudinal_Fasciculus_Rt >> loss_track_list.txt
fi

echo Rubrospinal_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=62 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Rubrospinal_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Lt.trk.gz --output=Rubrospinal_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Lt.trk.gz --output=Rubrospinal_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Rubrospinal_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Rubrospinal_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hRubrospinal_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Rubrospinal_Tract_Lt
cp *Rubrospinal_Tract_Lt* ${f}/Rubrospinal_Tract_Lt


if [ -e ${f}/Rubrospinal_Tract_Lt.trk.gz ]; then
echo STEP 5-63: Complete of Rubrospinal_Tract_Lt
fi

if [ ! -e ${f}/Rubrospinal_Tract_Lt.trk.gz ]; then
echo  Rubrospinal_Tract_Lt >> loss_track_list.txt
fi

echo Rubrospinal_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=63 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Rubrospinal_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Rt.trk.gz --output=Rubrospinal_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Rt.trk.gz --output=Rubrospinal_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Rubrospinal_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Rubrospinal_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Rubrospinal_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hRubrospinal_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Rubrospinal_Tract_Rt
cp *Rubrospinal_Tract_Rt* ${f}/Rubrospinal_Tract_Rt

if [ -e ${f}/Rubrospinal_Tract_Rt.trk.gz ]; then
echo STEP 5-64: Complete of Rubrospinal_Tract_Rt
fi

if [ ! -e ${f}/Rubrospinal_Tract_Rt.trk.gz ]; then
echo  Rubrospinal_Tract_Rt >> loss_track_list.txt
fi

echo Spinothalamic_Tract_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=64 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Spinothalamic_Tract_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Lt.trk.gz --output=Spinothalamic_Tract_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Lt.trk.gz --output=Spinothalamic_Tract_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Spinothalamic_Tract_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Spinothalamic_Tract_Lt.trk.gz3D.jpg+save_h3view_image,hSpinothalamic_Tract_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Spinothalamic_Tract_Lt
cp *Spinothalamic_Tract_Lt* ${f}/Spinothalamic_Tract_Lt


if [ -e ${f}/Spinothalamic_Tract_Lt.trk.gz ]; then
echo STEP 5-65: Complete of Spinothalamic_Tract_Lt
fi

if [ ! -e ${f}/Spinothalamic_Tract_Lt.trk.gz ]; then
echo  Spinothalamic_Tract_Lt >> loss_track_list.txt
fi

echo Spinothalamic_Tract_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=65 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/Spinothalamic_Tract_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Rt.trk.gz --output=Spinothalamic_Tract_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Rt.trk.gz --output=Spinothalamic_Tract_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=Spinothalamic_Tract_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=Spinothalamic_Tract_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,Spinothalamic_Tract_Rt.trk.gz3D.jpg+save_h3view_image,hSpinothalamic_Tract_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir Spinothalamic_Tract_Rt
cp *Spinothalamic_Tract_Rt* ${f}/Spinothalamic_Tract_Rt


if [ -e ${f}/Spinothalamic_Tract_Rt.trk.gz ]; then
echo STEP 5-66: Complete of Spinothalamic_Tract_Rt
fi

if [ ! -e ${f}/Spinothalamic_Tract_Rt.trk.gz ]; then
echo  Spinothalamic_Tract_Rt >> loss_track_list.txt
fi

echo CNII_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=66 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNII_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Lt.trk.gz --output=CNII_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Lt.trk.gz --output=CNII_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNII_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNII_Lt.trk.gz3D.jpg+save_h3view_image,hCNII_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNII_Lt
cp *CNII_Lt* ${f}/CNII_Lt


if [ -e ${f}/CNII_Lt.trk.gz ]; then
echo STEP 5-67: Complete of CNII_Lt
fi

if [ ! -e ${f}/CNII_Lt.trk.gz ]; then
echo  CNII_Lt >> loss_track_list.txt
fi

echo CNII_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=67 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNII_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Rt.trk.gz --output=CNII_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Rt.trk.gz --output=CNII_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNII_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNII_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNII_Rt.trk.gz3D.jpg+save_h3view_image,hCNII_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNII_Rt
cp *CNII_Rt* ${f}/CNII_Rt

if [ -e ${f}/CNII_Rt.trk.gz ]; then
echo STEP 5-68: Complete of CNII_Rt
fi

if [ ! -e ${f}/CNII_Rt.trk.gz ]; then
echo  CNII_Rt >> loss_track_list.txt
fi

echo CNIII_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=68 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNIII_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Lt.trk.gz --output=CNIII_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Lt.trk.gz --output=CNIII_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNIII_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNIII_Lt.trk.gz3D.jpg+save_h3view_image,hCNIII_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNIII_Lt
cp *CNIII_Lt* ${f}/CNIII_Lt


if [ -e ${f}/CNIII_Lt.trk.gz ]; then
echo STEP 5-69: Complete of CNIII_Lt
fi

if [ ! -e ${f}/CNIII_Lt.trk.gz ]; then
echo  CNIII_Lt >> loss_track_list.txt
fi

echo CNIII_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=69 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNIII_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Rt.trk.gz --output=CNIII_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Rt.trk.gz --output=CNIII_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIII_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNIII_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNIII_Rt.trk.gz3D.jpg+save_h3view_image,hCNIII_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNIII_Rt
cp *CNIII_Rt* ${f}/CNIII_Rt


if [ -e ${f}/CNIII_Rt.trk.gz ]; then
echo STEP 5-70: Complete of CNIII_Rt
fi

if [ ! -e ${f}/CNIII_Rt.trk.gz ]; then
echo  CNIII_Rt >> loss_track_list.txt
fi

echo CNIV_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=70 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNIV_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Lt.trk.gz --output=CNIV_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Lt.trk.gz --output=CNIV_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNIV_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNIV_Lt.trk.gz3D.jpg+save_h3view_image,hCNIV_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNIV_Lt
cp *CNIV_Lt* ${f}/CNIV_Lt


if [ -e ${f}/CNIV_Lt.trk.gz ]; then
echo STEP 5-71: Complete of CNIV_Lt
fi

if [ ! -e ${f}/CNIV_Lt.trk.gz ]; then
echo  CNIV_Lt >> loss_track_list.txt
fi

echo CNIV_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=71 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNIV_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Rt.trk.gz --output=CNIV_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Rt.trk.gz --output=CNIV_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNIV_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNIV_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNIV_Rt.trk.gz3D.jpg+save_h3view_image,hCNIV_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNIV_Rt
cp *CNIV_Rt* ${f}/CNIV_Rt


if [ -e ${f}/CNIV_Rt.trk.gz ]; then
echo STEP 5-72: Complete of CNIV_Rt
fi

if [ ! -e ${f}/CNIV_Rt.trk.gz ]; then
echo  CNIV_Rt >> loss_track_list.txt
fi

echo CNV_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=72 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNV_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Lt.trk.gz --output=CNV_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Lt.trk.gz --output=CNV_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNV_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNV_Lt.trk.gz3D.jpg+save_h3view_image,hCNV_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNV_Lt
cp *CNV_Lt* ${f}/CNV_Lt


if [ -e ${f}/CNV_Lt.trk.gz ]; then
echo STEP 5-73: Complete of CNV_Lt
fi

if [ ! -e ${f}/CNV_Lt.trk.gz ]; then
echo  CNV_Lt >> loss_track_list.txt
fi

echo CNV_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=73 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNV_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Rt.trk.gz --output=CNV_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Rt.trk.gz --output=CNV_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNV_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNV_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNV_Rt.trk.gz3D.jpg+save_h3view_image,hCNV_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNV_Rt
cp *CNV_Rt* ${f}/CNV_Rt


if [ -e ${f}/CNV_Rt.trk.gz ]; then
echo STEP 5-74: Complete of CNV_Rt
fi

if [ ! -e ${f}/CNV_Rt.trk.gz ]; then
echo  CNV_Rt >> loss_track_list.txt
fi

echo CNVII_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=74 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNVII_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Lt.trk.gz --output=CNVII_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Lt.trk.gz --output=CNVII_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNVII_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNVII_Lt.trk.gz3D.jpg+save_h3view_image,hCNVII_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNVII_Lt
cp *CNVII_Lt* ${f}/CNVII_Lt


if [ -e ${f}/CNVII_Lt.trk.gz ]; then
echo STEP 5-75: Complete of CNVII_Lt
fi

if [ ! -e ${f}/CNVII_Lt.trk.gz ]; then
echo  CNVII_Lt >> loss_track_list.txt
fi

echo CNVII_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=75 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNVII_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Rt.trk.gz --output=CNVII_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Rt.trk.gz --output=CNVII_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVII_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNVII_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNVII_Rt.trk.gz3D.jpg+save_h3view_image,hCNVII_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNVII_Rt
cp *CNVII_Rt* ${f}/CNVII_Rt


if [ -e ${f}/CNVII_Rt.trk.gz ]; then
echo STEP 5-76: Complete of CNVII_Rt
fi

if [ ! -e ${f}/CNVII_Rt.trk.gz ]; then
echo  CNVII_Rt >> loss_track_list.txt
fi

echo CNVIII_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=76 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNVIII_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Lt.trk.gz --output=CNVIII_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Lt.trk.gz --output=CNVIII_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNVIII_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNVIII_Lt.trk.gz3D.jpg+save_h3view_image,hCNVIII_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNVIII_Lt
cp *CNVIII_Lt* ${f}/CNVIII_Lt


if [ -e ${f}/CNVIII_Lt.trk.gz ]; then
echo STEP 5-77: Complete of CNVIII_Lt
fi

if [ ! -e ${f}/CNVIII_Lt.trk.gz ]; then
echo  CNVIII_Lt >> loss_track_list.txt
fi

echo CNVIII_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=77 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNVIII_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Rt.trk.gz --output=CNVIII_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Rt.trk.gz --output=CNVIII_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNVIII_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNVIII_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNVIII_Rt.trk.gz3D.jpg+save_h3view_image,hCNVIII_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNVIII_Rt
cp *CNVIII_Rt* ${f}/CNVIII_Rt


if [ -e ${f}/CNVIII_Rt.trk.gz ]; then
echo STEP 5-78: Complete of CNVIII_Rt
fi

if [ ! -e ${f}/CNVIII_Rt.trk.gz ]; then
echo  CNVIII_Rt >> loss_track_list.txt
fi

echo CNX_Lt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=78 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNX_Lt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Lt.trk.gz --output=CNX_Lt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Lt.trk.gz --output=CNX_Lt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Lt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Lt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNX_Lt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNX_Lt.trk.gz3D.jpg+save_h3view_image,hCNX_Lt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNX_Lt
cp *CNX_Lt* ${f}/CNX_Lt


if [ -e ${f}/CNX_Lt.trk.gz ]; then
echo STEP 5-79: Complete of CNX_Lt
fi

if [ ! -e ${f}/CNX_Lt.trk.gz ]; then
echo  CNX_Lt >> loss_track_list.txt
fi

echo CNX_Rt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=trk --source=${f}/qsdr.fib.gz --track_id=79 --parameter_id=5A35053D9A99193Fb803FdbF041b9643A08601dcaCDCC4C3E --output=${f}/CNX_Rt.trk.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Rt.trk.gz --output=CNX_Rt.txt
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Rt.trk.gz --output=CNX_Rt_ROI.nii.gz
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Rt.txt --export=tdi
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=ana --source=${f}/qsdr.fib.gz --tract=CNX_Rt.txt --export=stat
/Applications/dsi_studio.app/Contents/MacOS/dsi_studio --action=vis --source=${f}/qsdr.fib.gz --track=CNX_Rt.trk.gz --cmd=set_param,orientation_convention,0+set_zoom,1.0+save_3view_image,CNX_Rt.trk.gz3D.jpg+save_h3view_image,hCNX_Rt.trk.gz3D.jpg
cp *.jpg ${f}/JPG_folder
cp *.txt.stat.txt ${f}/Statistic_folder
mkdir CNX_Rt
cp *CNX_Rt* ${f}/CNX_Rt


if [ -e ${f}/CNX_Rt.trk.gz ]; then
echo STEP 5-80: Complete of CNX_Rt
fi

if [ ! -e ${f}/CNX_Rt.trk.gz ]; then
echo  CNX_Rt >> loss_track_list.txt
fi

mkdir Major_tracts
cp -r Arcuate_Fasciculus_Lt${f}/Major_tracts
cp -r Arcuate_Fasciculus_Rt${f}/Major_tracts
cp -r Acoustic_Radiation_Lt${f}/Major_tracts
cp -r Acoustic_Radiation_Rt ${f}/Major_tracts
cp -r Cingulum_Lt ${f}/Major_tracts
cp -r Cingulum_Rt ${f}/Major_tracts
cp -r Cortico_Spinal_Tract_Lt ${f}/Major_tracts
cp -r Cortico_Spinal_Tract_Rt ${f}/Major_tracts
cp -r Corticothalamic_Pathway_Lt ${f}/Major_tracts
cp -r Corticothalamic_Pathway_Rt ${f}/Major_tracts
cp -r Fornix_Lt ${f}/Major_tracts
cp -r Fornix_Rt ${f}/Major_tracts
cp -r Optic_Radiation_Lt ${f}/Major_tracts
cp -r Optic_Radiation_Rt ${f}/Major_tracts
cp -r Rubrospinal_Tract_Lt ${f}/Major_tracts
cp -r Rubrospinal_Tract_Rt ${f}/Major_tracts
cp -r Spinothalamic_Tract_Lt ${f}/Major_tracts
cp -r Spinothalamic_Tract_Rt ${f}/Major_tracts

mkdir Cranial_nerves

cp -r *_CN* ${f}/Cranial_nerves

echo echo STEP 5: COMPLETE OF FIBER TRACKING






