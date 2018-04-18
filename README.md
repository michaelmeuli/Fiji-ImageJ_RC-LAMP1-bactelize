# Fiji-ImageJ_RC-LAMP1-bactelize
Measuring colocalization of bacteria and lysosomes in macrophages with Fiji-ImageJ macros.

Workflow:
1. Infection of macrophages
2. Confocal Microscopy
3. Deconvolution with Huygens Professional
4. LAMP1-merge-decon-3D.ijm
5. LAMP1-crop-3D.ijm
6. LAMP1-seg.ijm
7. LAMP1-bactelize.ijm

| Fluorochrome    | Excitation (nm)   | Emission (nm)  |
| --------------- | ----------------- | -------------- |
| DAPI            | 358               | 461            |
| Alexa Fluor 488 | 499               | 519            |
| Alexa Fluor 594 | 590               | 617            |


### Huygens Professional:  
Deconvolve images with Huygens Professional:
http://www.zmb.uzh.ch/en/Instruments-and-tools/Image-processing-tools/Software/Huygens-Professional.html  
To use Hygens Professional use the Citrix Reiceiver to log onto a Virtual machine (VM) of the Center for Microscopy and Images Analysis of the University of Zurich:
http://www.zmb.uzh.ch/en/Howtos/How-to-use-an-image-processing-virtual-machine.html  
You need to reserve the virtual machine first in the reservation system using your Artologik login which your received when you registered as a ZMB user. For this use the “Reservation system” link below the “Quick Links” on http://www.zmb.uzh.ch


### Fiji:  
Fiji is an image processing package. It can be described as a "batteries-included" distribution of ImageJ (and ImageJ2), bundling Java, Java3D and a lot of plugins organized into a coherent menu structure:  
http://fiji.sc/Fiji  



### Region Competition:  
J. Cardinale, G. Paul, and I. F. Sbalzarini. Discrete region competition for unknown numbers of connected regions. IEEE Trans. Image Process., 21(8):3531–3545, 2012. 
http://mosaic.mpi-cbg.de/?q=downloads/RCITK  

Region Competition is also available as plugin for Fiji:  
http://mosaic.mpi-cbg.de/?q=downloads/imageJ  
http://mosaic.mpi-cbg.de/MosaicToolboxSuite/MosaicToolsuiteTutorials.html  

Lif_extractor.ijm is to be used with Fiji and is taken from Supplementary Data to:  
A. Rizk, G. Paul, P. Incardona, M. Bugarski, M. Mansouri, A. Niemann, U. Ziegler, P. Berger, and I. F. Sbalzarini. Segmentation and quantification of subcellular structures in fluorescence microscopy images using Squassh. Nature Protocols, 9(3):586–596, 2014.  
http://mosaic.mpi-cbg.de/?q=downloads/imageJ 


### 3D ImageJ Suite:  
This “suite” is composed of :  
3D Filters (mean, median, max, min, tophat, max local, …) and edge and symmetry filter   
3D Segmentation (hysteresis thresholding, spots segmentation, watershed, …)   
3D Mathematical Morphology tools (fill holes, binary closing, distance map, …)   
3D RoiManager (3D display and analysis of 3D objects)  
3D Analysis (Geometrical measurements, Mesh measurements, Convex hull, …)   
3D MereoTopology (Relationship between objects)  
3D Tools (Drawing ellipsoids and lines, cropping, …)   
A 2D/3D spatial statistics plugin is also available.  
http://imagejdocu.tudor.lu/doku.php?id=plugin:stacks:3d_ij_suite:start#d_imagej_suite
