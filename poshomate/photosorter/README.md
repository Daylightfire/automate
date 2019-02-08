# image sorter

## Brief / Business case

A request for a script which can sort through potentially thousands of images and sort them into folders via the meta data.

### Goals

1. Rename each file to include the date the image was taken 
2. Create a directory for that date and copy the image into that folder

### Progress

1. Used function from PoSh Gallery to get metadata
2. Create function to rename and sort images based on the Date Taken

### To do

1. Make Recursive and include get-childitem count to handle multiple photos from one day that are not in order
2. Check for any improvements in both functions ie, speed, efficiency etc
3. Modulise script
4. Look for exe possibilities
5. improve ease of use