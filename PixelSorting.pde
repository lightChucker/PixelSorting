/*
  Project Description: This is a pixel sorting program based on brightness. It will resize to the input image. 
  It will start by sorting the pixels vertically, then when clicked it will sort them horizontally alternating between the two upon each successive click.  
  Last Modified: 10/8/24
  */


import java.util.Arrays;  
PImage img;
int currentColumn = 0;
int currentRow = 0;
int[][] pixelsArray;
boolean sortingComplete = false;
boolean verticalSorting = true;  // Start with vertical sorting

void setup() {
  size(400,400); 
  img = loadImage("rose.jpg"); // Load the input image      
  img.loadPixels();            // Load the image pixels into an array
  
  // Create a 2D array to hold pixel colors for each column
  pixelsArray = new int[img.width][img.height];
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      pixelsArray[x][y] = img.pixels[x + y * img.width];
    }
  }
}

void draw() {
  windowResize(img.width, img.height);
  image(img, 0, 0, width, height);

  if (!sortingComplete) {
    if (verticalSorting) {
      sortColumn(currentColumn);  // Sort column by column
      currentColumn++;
      
      if (currentColumn >= img.width) {
        sortingComplete = true;  // Stop when all columns are sorted
      }
    } else {
      sortRow(currentRow);  // Sort row by row
      currentRow++;
      
      if (currentRow >= img.height) {
        sortingComplete = true;  // Stop when all rows are sorted
      }
    }
  }

  // Display the sorted pixels
  img.updatePixels();
  image(img, 0, 0);
}

void sortColumn(int column) {
  // Extract the current column of pixels
  Integer[] columnPixels = new Integer[img.height];  // Integer array to use with Arrays.sort()
  for (int y = 0; y < img.height; y++) {
    columnPixels[y] = pixelsArray[column][y];
  }
  
  // Sort the column pixels using brightness with a custom comparator
  Arrays.sort(columnPixels, (c1, c2) -> floatCompare(brightness(color(c1)), brightness(color(c2))));
  
  // Update the image pixels with sorted column
  for (int y = 0; y < img.height; y++) {
    img.pixels[column + y * img.width] = columnPixels[y];
  }
}

void sortRow(int row) {
  // Extract the current row of pixels
  Integer[] rowPixels = new Integer[img.width];  // Integer array to use with Arrays.sort()
  for (int x = 0; x < img.width; x++) {
    rowPixels[x] = pixelsArray[x][row];
  }
  
  // Sort the row pixels using brightness with a custom comparator
  Arrays.sort(rowPixels, (c1, c2) -> floatCompare(brightness(color(c1)), brightness(color(c2))));
  
  // Update the image pixels with sorted row
  for (int x = 0; x < img.width; x++) {
    img.pixels[x + row * img.width] = rowPixels[x];
  }
}

// Helper function to compare brightness
int floatCompare(float a, float b) {
  return a < b ? -1 : a > b ? 1 : 0;
}

void mousePressed() {
  // Toggle between vertical and horizontal sorting on mouse click
  sortingComplete = false;  // Reset the sorting
  currentColumn = 0;
  currentRow = 0;
  verticalSorting = !verticalSorting;  // Toggle sorting direction
}
