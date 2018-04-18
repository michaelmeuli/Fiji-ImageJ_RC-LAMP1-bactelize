x=900; y=0;
width=0.0450498;
height=0.0450498;
depth=0.2985003;

inputDir = getDirectory("Choose the Directory of the input files. ");
outputDir = getDirectory("Choose the Directory for the output files. ");
list = getFileList(inputDir);
count = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_orig.tif")) {
		count++;
	}
}
print("Number of _orig.tif files: " + count);
segFiles = newArray(count);
segFilesCount = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_orig.tif")) {
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
//	repeatcomposite	= false;
	filename = segFiles[filenumber];
		
	print("Opening file: " + filename);
	open(filename);	
	title4D = getTitle(); 
	selectWindow(title4D);
	run("Properties...", "pixel_width=" + width + " pixel_height=" + height + " voxel_depth=" + depth);	
	run("Set... ", "zoom=150"); 
	setLocation(900, 220);
	getDimensions(w, h, channels, slices, frames);
	m_slice = slices/2;
	Stack.setPosition(1, m_slice, 1);
	run("Green"); 
	run("Enhance Contrast", "saturated=0.5");
	Stack.setPosition(2, m_slice, 1);
	run("Red"); 
	run("Enhance Contrast", "saturated=0.5");
	Stack.setPosition(3, m_slice, 1);
	run("Blue"); 
	run("Enhance Contrast", "saturated=0.5");
	run("Make Composite");
	for (i=1; i<=slices; i++) {
		Stack.setPosition(1, i, 1);
		wait(40);
	}
	for (i=slices; i>=1; i--) {
		Stack.setPosition(1, i, 1);
		wait(40);
	}	
	Stack.setPosition(1, m_slice, 1);

	call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
	waitForUser("Select region to crop.");
	run("Crop");

	call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
	waitForUser("Check slice numbers:");
	Dialog.create("Enter filenumber:");
	Dialog.addNumber("First sclice number:", 0);
	Dialog.addNumber("Last sclice number:", 1);
	Dialog.setLocation(x,y);
	Dialog.show();
	z_number_1 = Dialog.getNumber();
	z_number_2 = Dialog.getNumber();
	run("Duplicate...", "duplicate slices=" + z_number_1 + "-" + z_number_2);
	title4D = getTitle(); 
	run("Duplicate...", "duplicate");
	title4D_tmp = getTitle(); 
	run("Split Channels");
	c1Title = "C1-" + title4D_tmp; 
	c2Title = "C2-" + title4D_tmp; 
	c3Title = "C3-" + title4D_tmp; 
	selectWindow(c1Title);
	getDimensions(w, h, channels, slices, frames);
	m_slice = slices/2;
	run("Set... ", "zoom=150");
	setSlice(m_slice);
	setLocation(100, 220);
	selectWindow(c2Title);
	run("Set... ", "zoom=150"); 
	setSlice(m_slice);
	setLocation(500, 220);
	selectWindow(c3Title);
	run("Set... ", "zoom=150"); 
	setSlice(m_slice);
	setLocation(100, 620);
	wait(100);

	fileT = File.getName(filename); 
	indexT=indexOf(fileT, "_orig.tif");
	fileSubstring=substring(fileT, 0, indexT+1);
	
	selectWindow(title4D);
	resultComp = outputDir + fileSubstring + "composite.tif";
	saveAs("Tiff", resultComp);
	selectWindow(c1Title);
	resultB = outputDir + fileSubstring + "bacteria.tif";
	saveAs("Tiff", resultB);
	selectWindow(c2Title);
	resultL = outputDir + fileSubstring + "lysosomes.tif";
	saveAs("Tiff", resultL);
	selectWindow(c3Title);
	resultM = outputDir + fileSubstring + "macrophage.tif";
	saveAs("Tiff", resultM);
	
	while (nImages>0) { 
		selectImage(nImages); 
		close(); 
	}
	filenumber++;
}
