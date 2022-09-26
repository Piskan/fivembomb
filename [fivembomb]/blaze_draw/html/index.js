window.addEventListener('message', function (event) {
  var gostereyimmi = event.data.goster,
        yazim =     event.data.text,
        gelentur = event.data.tur;

  if (gostereyimmi == true) {
   
    
    if (gelentur == 'mavi') {
      
      this.document.getElementById('interaction-holder').style.animation = "fadeInRight 0.1s forwards";
      this.document.getElementById('interaction-holder').style.display = "flex";
      this.document.getElementById('interaction-text').innerHTML = yazim;
      this.document.getElementById('interaction-holder').style.backgroundColor = "#03a9f4";

     } else if (gelentur == 'kirmizi') {
       
      this.document.getElementById('interaction-holder').style.animation = "fadeInRight 0.1s forwards";
      this.document.getElementById('interaction-holder').style.display = "flex";
      this.document.getElementById('interaction-holder').style.backgroundColor = "#f44336";

      this.document.getElementById('interaction-text').innerHTML = yazim;
     } else if (gelentur == 'yesil') {
   

      this.document.getElementById('interaction-holder').style.animation = "fadeInRight 0.1s forwards";
      this.document.getElementById('interaction-holder').style.display = "flex";
      this.document.getElementById('interaction-holder').style.backgroundColor = "#4caf50";

      this.document.getElementById('interaction-text').innerHTML = yazim;
    } else{
      this.document.getElementById('interaction-holder').style.animation = "fadeInRight 0.1s forwards";
      this.document.getElementById('interaction-holder').style.display = "flex";
      this.document.getElementById('interaction-text').innerHTML = yazim;
      this.document.getElementById('interaction-holder').style.backgroundColor = "#03a9f4";

     }

  } else {
    this.document.getElementById('interaction-holder').style.animation = "fadeInLeft 0.1s forwards";
    setTimeout(() => {
      this.document.getElementById('interaction-holder').style.display = "none";
      
  }, 500);
    
 
    // $("#interaction-holder").hide();
  }

  
 
    
  
})
  