// Converts the manually curated myotube masks to 8-bit.
// Run in batch mode so image windows are not shown.
setBatchMode(true);


// Define output folder
projectDir = getDirectory("Choose the trainingDataset/myotubes folder");
outputFolder = projectDir + "curated_8_bits/";

// Ensure the directories exist before proceeding
if (!File.exists(outputFolder)) File.makeDirectory(outputFolder);


// Get the list of all files in the directory
inputFolder = projectDir + "curatedTarget_1606_Patricia/";
list = getFileList(inputFolder);


for (f = 0; f < lengthOf(list); f++) {
	fileName = list[f];
	open(inputFolder + fileName);
	run("8-bit");
	saveAs("Tiff", outputFolder + fileName);
	close();

}
setBatchMode(false);  // Restore normal mode