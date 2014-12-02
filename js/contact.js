//contact.js:
//chooses a random image out of the /img/contact-bg folder
//and affixes it as background on contact.html

//unfortunately, we need to update this every time we add a
//new file to /img/contact-bg... figure out way to deal with
//this issue later?
files = [
    "path1.jpg",
    "path2.jpg",
    "path3.jpg"
];

var rdm = Math.floor(Math.random() * filePaths.length);

var randomImg = files[rdm];
document.getElementById("bgImg").src = randomImg;
