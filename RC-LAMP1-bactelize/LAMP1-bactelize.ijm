x=900; y=0;
width=0.0450498;
height=0.0450498;
depth=0.1502038;

inputDir = getDirectory("Choose the Directory of the input files. ");
outputDir = getDirectory("Choose the Directory for the output files. ");

list = getFileList(inputDir);
count = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_labeled.tif")) {
		count++;
	}
}
print("Number of _labeled.tif files: " + count);
segFiles = newArray(count);
segFilesCount = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_labeled.tif")) {
		segFiles[segFilesCount] = inputDir + list[i];
		print((segFilesCount) + ": " + list[i]);
		segFilesCount++;
	}
}

script = 
"lw = WindowManager.getFrame('Log');\n"+ 
"if (lw!=null) {\n"+ 
"   lw.setLocation(100,250);\n"+ 
"   lw.setSize(800, 900)\n"+ 
"}\n"; 
eval("script", script); 

call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
waitForUser("Check filenumber to start with:");
Dialog.create("Enter filenumber:");
Dialog.addNumber("Filenumber:", 0);
Dialog.setLocation(x,y);
Dialog.show();
filenumber = Dialog.getNumber();

while (filenumber < segFilesCount) {
	repeatcomposite	= false;
	filename = segFiles[filenumber];
	
	fileT = File.getName(filename); 
	indexT=indexOf(fileT, "_labeled.tif");
	fileSubstring=substring(fileT, 0, indexT+1);
	
	print("Opening file: " + filename);
	open(filename);
	titleSeg = getTitle(); 
	selectWindow(titleSeg);
	run("Properties...", "pixel_width=" + width + " pixel_height=" + height + " voxel_depth=" + depth);
	run("Set... ", "zoom=150"); 
	setLocation(50, 150);
	getDimensions(w, h, channels, slices, frames);
	m_slice = slices/2;
	Stack.setPosition(1, m_slice, 1);
	run("Clear Results");
	run("Statistics"); 
	min=getResult("Min", 0);
	max=getResult("Max", 0);
	selectWindow("Results"); 
	run("Close");
	setMinAndMax(min, max);
	run("3-3-2 RGB");
	Stack.setPosition(1, m_slice, 1);
	for (i=1; i<=slices; i++) {
		Stack.setPosition(1, i, 1);
		wait(100);
	}
	for (i=slices; i>=1; i--) {
		Stack.setPosition(1, i, 1);
		wait(100);
	}	
	Stack.setPosition(1, m_slice, 1);

	open(inputDir + fileSubstring + "lysosomes.tif");
	c2Title = getTitle(); 
	selectWindow(c2Title);
	run("Properties...", "pixel_width=" + width + " pixel_height=" + height + " voxel_depth=" + depth);
	run("Set... ", "zoom=150");
	setLocation(1000, 50);
	setSlice(nSlices/2);
	run("Red"); 
	run("Enhance Contrast", "saturated=1");
	
	open(inputDir + fileSubstring + "bacteria.tif");
	c1Title = getTitle(); 
	selectWindow(c1Title);
	run("Properties...", "pixel_width=" + width + " pixel_height=" + height + " voxel_depth=" + depth);	
	run("Set... ", "zoom=150");
	setLocation(1400, 50);
	setSlice(nSlices/2);
	run("Green"); 
	run("Enhance Contrast", "saturated=1");

	run("3D Manager");
	selectWindow(titleSeg);
	Ext.Manager3D_AddImage();
	Ext.Manager3D_Count(nb);
	Ext.Manager3D_Quantif3D(0, "Mean", meanM);
	run("Duplicate...", "duplicate");
	run("RGB Color");
	titleSegRGB = getTitle();
	Ext.Manager3D_MonoSelect();
	Ext.Manager3D_DeselectAll();
	for(i=0;i<nb;i++) {
		selectWindow(c2Title);
		Ext.Manager3D_Quantif3D(i, "Mean", meanR_forRGB);
	    mfr=meanR_forRGB/5000;
		if (mfr>1) mfr=1;
	    selectWindow(titleSegRGB);
	    Ext.Manager3D_Select(i);
    	Ext.Manager3D_FillStack(255, 255*mfr, 255*mfr);    
	}
		
	selectWindow(c1Title);
	run("Green");
	run("Duplicate...", "duplicate");
	run("RGB Color");
	c1TitleRGB = getTitle();
	selectWindow(c1TitleRGB);

	imageCalculator("Add create stack", c1TitleRGB, titleSegRGB);
  	showImage = getTitle();
  	selectWindow(showImage);
  	run("Set... ", "zoom=150");
  	setLocation(450, 150);
  	getDimensions(w, h, channels, slices, frames);
	m_slice = slices/2;
  	Stack.setPosition(1, m_slice, 1);
	for (i=1; i<=slices; i++) {
		Stack.setPosition(1, i, 1);
		wait(100);
	}
	for (i=slices; i>=1; i--) {
		Stack.setPosition(1, i, 1);
		wait(100);
	}	
	Stack.setPosition(1, m_slice, 1);
	run("Orthogonal Views");

	wait(500);
  	selectWindow(titleSeg);

  	call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
	waitForUser("Deselect unwanted objects.");
	
	//Format:	cNr	iNr	label	x	y	z	pSize	pixels	maxDiameter	minDiameter	roundness	lysosome	macrophage
	//Quantif3D: The object number and the type of measure ("IntDen", "Mean", "Min", "Max", "Sigma") 
	//Measure3D: The object number and the type of measure ("Vol", "Surf", “NbVox”, "Comp", "Feret", "Elon1", "Elon2", "DCMin", "DCMax", "DCMean", "DCSD")	
	resultF = outputDir + fileSubstring + "result.txt";
	f = File.open(resultF);
	Ext.Manager3D_Count(nb_obj);
	for (object=0; object < nb_obj; object++) {
		selectWindow(c2Title);
		Ext.Manager3D_Quantif3D(object, "Mean", mean);
		
		selectWindow(titleSeg);
		Ext.Manager3D_Centroid3D(object, cx, cy, cz);
		Ext.Manager3D_Measure3D(object,"Vol",volume);
		Ext.Manager3D_Measure3D(object,"NbVox",nbVox);
		Ext.Manager3D_Measure3D(object,"Elon1",elon1);
		Ext.Manager3D_Measure3D(object,"Elon2",elon2);
		Ext.Manager3D_Quantif3D(object, "Mean", meanSeg);
		
		print(f, "0" + "\t" + fileSubstring + "\t" + meanSeg + "\t" + (cx*width) + "\t" + (cy*height) + "\t" + (cz*depth) + "\t" + volume + "\t" + nbVox + "\t" + elon1 + "\t" + elon2 + "\t" + 1 + "\t" + d2s(mean,3) + "\t" + "0" + "\n");
	}
	objectsFile = outputDir + fileSubstring + "_objects.zip";
	Ext.Manager3D_Save(objectsFile);
	File.close(f);
	Ext.Manager3D_Close();
	
	call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
	waitForUser("Click for next image");
	while (nImages>0) { 
		selectImage(nImages); 
		close(); 
	}

	filenumber++;
}
