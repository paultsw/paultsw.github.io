//contact.js:
//chooses a random image out of the /img/contact-bg folder
//and affixes it as background on contact.html

//unfortunately, we need to update this every time we add a
//new file to /img/contact-bg... figure out way to deal with
//this issue later?
files = [
    ["carina_nebula.jpg", "The Carina Nebula. Public domain via NASA/ESA."],
    ["kelvin_helmholtz.jpg", "Kelvin-Helmholtz Billlows. CC-SA-3.0 by Lgostiau."],
    ["baffin.jpg", "Baffin Island. CC-SA-2.5 by Ansgar Walk."]
];

var rdm = Math.floor(Math.random() * filePaths.length);

var randomImg = files[rdm];
document.getElementById("bgImg").src = "../img/contact-bg/"+randomImg[0];
document.getElementById("bgImg").name = randomImg[1];
