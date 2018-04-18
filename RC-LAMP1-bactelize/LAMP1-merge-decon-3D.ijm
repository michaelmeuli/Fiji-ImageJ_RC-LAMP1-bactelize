setBatchMode(true); 
inputDir = getDirectory("Choose the Directory of the input files. ");
outputDir = getDirectory("Choose the Directory for the output files. ");

list = getFileList(inputDir);
count = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_ch00.tif")) {
		count++;
	}
}

ch00_Files = newArray(count);
ch00_FilesCount = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_ch00.tif")) {
		ch00_Files[ch00_FilesCount] = inputDir + list[i];
		print((ch00_FilesCount) + ": " + list[i]);
		ch00_FilesCount++;
	}
}



filenumber = 0;

while (filenumber < ch00_FilesCount) {
	filename = ch00_Files[filenumber];

	fileT = File.getName(filename); 
	indexT=indexOf(fileT, "_ch00");
	fileNr=substring(fileT, 0, indexT+1);
	imageName=inputDir + fileNr + "ch00.tif";

	open(inputDir + fileNr + "ch00.tif");
	c1Title = getTitle(); 
	selectWindow(c1Title);	
	run("Set... ", "zoom=70");
	setLocation(500, 80);
	setSlice(nSlices/2);
	run("Green"); 
	run("Enhance Contrast", "saturated=1");

	open(inputDir + fileNr + "ch01.tif");
	c2Title = getTitle(); 
	selectWindow(c2Title);
	run("Set... ", "zoom=70");
	setLocation(1000, 80);
	setSlice(nSlices/2);
	run("Red"); 
	run("Enhance Contrast", "saturated=1");

	open(inputDir + fileNr + "ch02.tif");
	c3Title = getTitle(); 
	selectWindow(c3Title);	
	run("Set... ", "zoom=70");
	setLocation(1500, 80);
	setSlice(nSlices/2);
	run("Blue"); 
	run("Enhance Contrast", "saturated=1");

	run("Merge Channels...", "c1=[" + c1Title + "] " + "c2=[" + c2Title + "] " + "c3=[" + c3Title + "] " + "create keep ignore");
	title4D = getTitle(); 
	selectWindow(title4D);	
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
		wait(50);
	}
	for (i=slices; i>=1; i--) {
		Stack.setPosition(1, i, 1);
		wait(50);
	}	
	Stack.setPosition(1, m_slice, 1);

	run("Brightness/Contrast...");

	selectWindow(title4D);
	FourDcomposite = outputDir + fileNr + "orig.tif";
	print(FourDcomposite);
	saveAs("Tiff", FourDcomposite);

	while (nImages>0) { 
		selectImage(nImages); 
		close(); 
	}

	filenumber++;
}


