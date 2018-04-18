
//E data: e_PC
//E length: Sphere_Regularization
//Initializatioin: LocalMax
//Region Competition Parameters
//no fusion, no fission, handles yes
//Lambda E length: 0.0400
//Theta E merge: 0.100
//Max Iterations: 300
//Oscillation threshold (convergence): 0.0200
//Curvature based gradient flow option: 8
//Local Max Initialization:
//Radius: 10
//Sigma: 3
//Tolerance: 0.4
//Region Tol: 20

setBatchMode(true);
x=900; y=0;
call("ij.gui.WaitForUserDialog.setNextLocation",x,y);
waitForUser("Run Region competition before this Macro to set all parameters correct");

inputDir = getDirectory("Choose the Directory of the input files. ");
outputDir = getDirectory("Choose the Directory for the output files. ");
list = getFileList(inputDir);
count = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_lysosomes.tif")) {
		count++;
	}
}

print("Number of _lysosomes.tif files = " + count);
bacFiles = newArray(count);
bacFilesCount = 0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "_lysosomes.tif")) {
		bacFiles[bacFilesCount] = inputDir + list[i];
		print((bacFilesCount) + ": " + list[i]);
		bacFilesCount++;
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

while (filenumber < bacFilesCount) {	
	filename = bacFiles[filenumber];

	fileT = File.getName(filename); 
	indexT=indexOf(fileT, "_lysosomes.tif");
	fileSubstring=substring(fileT, 0, indexT+1);
	 
	print("Opening file: " + filename);
	open(filename);
	title = getTitle(); 
	selectWindow(title);
	run("Region Competition", "e_data=e_PC e_length=Sphere_Regularization lambda=0.040 theta=0.100 max_iterations=300 oscillation=0.0200 initialization=LocalMax fusion fission handles inputimage=[title] labelimage=[]");
  	titleSeg = getTitle(); 
	selectWindow(titleSeg);
	resultS = outputDir + fileSubstring + "labeled.tif";
	saveAs("Tiff", resultS);
	
	while (nImages>0) { 
		selectImage(nImages); 
		close(); 
	}

	filenumber++;
}





