let time = null;
let time2 = time;
let bombId = 0;
let scene = document.querySelector("#scene");
  
var wireArray = [].slice.call(document.querySelectorAll("#wires path"));

var shadowArray = [].slice.call(document.querySelectorAll("#wire-shadow g"));
let wire1 = document.querySelector("#wire1");
let wire2 = document.querySelector("#wire2");
let wire3 = document.querySelector("#wire3");
let wire4 = document.querySelector("#wire4");
let wire5 = document.querySelector("#wire5");
let wire6 = document.querySelector("#wire6");
let wireAmount;
let counter;
let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
let evenNumb = "02468";
let oddNumb = "13579";
let colorArray = [{
	color: "yellow",
	amount: 0
}, {
	color: "red",
	amount: 0
}, {
	color: "black",
	amount: 0
}, {
	color: "white",
	amount: 0
}, {
	color: "blue",
	amount: 0
}];
let serialNumber = "";
let amountBeaten = 0;
let amountError = 0;
var audioPlayer = null;
 
$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
			if (event.data.enable) {
				bombId = event.data.bombId;
				document.body.style.display = "block";
				time = parseInt(event.data.timeLeft);
				time2 = time;
				startGame(time);
				
			} else {
				document.body.style.display = "none";
			}
            
			//console.log(time);
			
        }

        if (event.data.transactionType == "playSound") {
				
            if (audioPlayer != null) {
              audioPlayer.pause();
            }
            //  console.log(event.data.transactionFile)
            audioPlayer = new Howl({src: ["./" + event.data.transactionFile + ".wav"]});
            audioPlayer.volume(event.data.transactionVolume);
            audioPlayer.play();
    
        }
    });
	
	window.addEventListener('message', function(event) {
        if (event.data.type == "updateTime") {
			time = event.data.timeLeft;
			time2 = time;
            document.querySelector("#countdown").innerHTML = `${time2}`;
        }
    });

	document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
			console.log(bombId)
			resetFunc();
			setTimeout(function(){ location.reload(); }, 500);
            $.post('http://fivembomb/escape', JSON.stringify({
				bomb: bombId
				}));
        }
    };
});

  "use strict";

  function startGame(time) {
      chooseWires();
      checkColors();
      makeSerialNumber();
      ifFunc();
      displayText();
      onHover();
      wrongEvent();
      //countdown(time);
  };


  function chooseWires() {
      wireAmount = Math.floor(Math.random() * 4) + 3;

      for (let i = 0; i < wireAmount; i++) {
          wireArray[i].style.display = "block";
          wireArray[i].style.stroke = colorArray[Math.floor(Math.random() * colorArray.length)].color;


          for (let ii = 0; ii < colorArray.length; ii++) {
              if (wireArray[i].style.stroke == colorArray[ii].color) {
                  wireArray[i].classList.add(colorArray[ii].color);
              };
          };
      };
  };
  
  function checkColors() {
      for (let i = 0; i < wireAmount; i++) {
          for (let ii = 0; ii < colorArray.length; ii++) {
              if (wireArray[i].style.stroke == colorArray[ii].color) {
                  colorArray[ii].amount = colorArray[ii].amount + 1;
              };
          };
      };
  };

  function makeSerialNumber() {
      for (var i = 0; i < 5; i++) {
          serialNumber += alphabet.charAt(Math.floor(Math.random() * alphabet.length));
      };
      serialNumber += (Math.floor(Math.random() * 10))
  };

  function displayText() {
      document.querySelector("#p1").innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + serialNumber;
  }

  function cutRightWire() {
      green.style.opacity = "1";
  };

  function wrongEvent() {
      wireArray.forEach(element => {
          element.removeEventListener("click", isItWrong);
      });
      wireArray.forEach(element => {
          element.addEventListener("click", isItWrong);
      });
  };

  function isItWrong() {
      this.style.strokeDasharray = "22%";
      if (document.querySelector("#green").style.opacity == "1") {
          // RIGHT
		  resetFunc();
		  setTimeout(function(){ location.reload(); }, 500);
		  $.post('http://fivembomb/process', JSON.stringify({
			state: true
			}));
			
      } else {
          // WRONG
		  resetFunc();
          setTimeout(function(){ location.reload(); }, 500);
		  $.post('http://fivembomb/process', JSON.stringify({
			state: false
			}));
			
      };
  };

  function onHover() {
      for (let i = 0; i < wireArray.length; i++) {
          wireArray[i].addEventListener("mouseover", function() {
              shadowArray[i].style.display = "block";
          })
          wireArray[i].addEventListener("mouseleave", function() {
              shadowArray[i].style.display = "none";
          })
      }
  }

  function resetFunc() {
      amountBeaten++;
      for (let i = 0; i < wireAmount; i++) {
          wireArray[i].removeEventListener("click", cutRightWire);
          for (let ii = 0; ii < colorArray.length; ii++) {
              if (wireArray[i].style.stroke == colorArray[ii].color) {
                  wireArray[i].classList.remove(colorArray[ii].color);
              };
          };
      };
      setTimeout(() => {
          for (let i = 0; i < wireAmount; i++) {
              wireArray[i].style.display = "none";
          };
      }, 900);

      setTimeout(function() {
          serialNumber = "";
          green.style.opacity = "0";
          colorArray = [{
              color: "yellow",
              amount: 0
          }, {
              color: "red",
              amount: 0
          }, {
              color: "black",
              amount: 0
          }, {
              color: "white",
              amount: 0
          }, {
              color: "blue",
              amount: 0
          }];
          wireArray.forEach(element => {
              element.style.strokeDasharray = "";
          });
      }, 1300)


      //console.log("reset");
  }

  function ifFunc() {
      if (wireAmount == 3) {
          wiresThree();
      } else if (wireAmount == 4) {
          wiresFour();
      } else if (wireAmount == 5) {
          wiresFive();
      } else {
          wiresSix();
      }
  }

  // 3 Wires
  function wiresThree() {
      //console.log("3 wires");
      if (colorArray[1].amount == 0) {
          // If there are no red wires, cut the second wire.
          wireArray[1].addEventListener("click", cutRightWire);
      } else if (wireArray[2].style.stroke == colorArray[3].color) {
          // Otherwise, if the last wire is white, cut the last wire.
          wireArray[2].addEventListener("click", cutRightWire);
      } else if (colorArray[4].amount > 1) {
          // Otherwise, if there is more than one blue wire, cut the last blue wire.
          let blueWires = document.querySelectorAll(".blue");
          blueWires[blueWires.length - 1].addEventListener("click", cutRightWire);
      } else {
          // Otherwise, cut the last wire.
          wireArray[2].addEventListener("click", cutRightWire);
      }
  }

  // 4 Wires
  function wiresFour() {
      //console.log("4 wires");
      // If there is more than one red wire and the last digit of the serial number is odd, cut the last red wire.
      let lastCharacter = serialNumber.slice(-1);

      if (colorArray[1].amount > 1 && oddNumb.includes(lastCharacter)) {
          let redWires = document.querySelectorAll(".red");
          redWires[redWires.length - 1].addEventListener("click", cutRightWire);
      } else if (wireArray[3].style.stroke == colorArray[0].color && colorArray[1].amount == 0) {
          // Otherwise, if the last wire is yellow and there are no red wires, cut the first wire.
          wireArray[0].addEventListener("click", cutRightWire);
      } else if (colorArray[4].amount == 1) {
          // Otherwise, if there is exactly one blue wire, cut the first wire.
          wireArray[0].addEventListener("click", cutRightWire);
      } else if (colorArray[0].amount > 1) {
          // Otherwise, if there is more than one yellow wire, cut the last wire.
          wireArray[3].addEventListener("click", cutRightWire);
      } else {
          // Otherwise, cut the second wire.
          wireArray[1].addEventListener("click", cutRightWire);
      }
  }


  // 5 Wires
  function wiresFive() {
      //console.log("5 wires");
      // If the last wire is black and the last digit of the serial number is odd, cut the fourth wire.
      let lastCharacter = serialNumber.slice(-1);
      if (wireArray[4].style.stroke == colorArray[2].color && oddNumb.includes(lastCharacter)) {
          wireArray[3].addEventListener("click", cutRightWire);
      } else if (colorArray[1].amount == 1 && colorArray[0].amount > 1) {
          // Otherwise, if there is exactly one red wire and there is more than one yellow wire, cut the first wire.
          wireArray[0].addEventListener("click", cutRightWire);
      } else if (colorArray[2].amount == 0) {
          // Otherwise, if there are no black wires, cut the second wire.
          wireArray[1].addEventListener("click", cutRightWire);
      } else {
          // Otherwise, cut the first wire.
          wireArray[0].addEventListener("click", cutRightWire);
      }
  }


  // 6 Wires
  function wiresSix() {
      //console.log("6 wires");
      // If there are no yellow wires and the last digit of the serial number is odd, cut the third wire.
      let lastCharacter = serialNumber.slice(-1);
      if (colorArray[0].amount == 0 && oddNumb.includes(lastCharacter)) {
          wireArray[2].addEventListener("click", cutRightWire);
      } else if (colorArray[0].amount == 1 && colorArray[3].amount > 1) {
          // Otherwise, if there is exactly one yellow wire and there is more than one white wire, cut the fourth wire.
          wireArray[3].addEventListener("click", cutRightWire);
      } else if (colorArray[1].amount == 0) {
          // Otherwise, if there are no red wires, cut the last wire.
          wireArray[5].addEventListener("click", cutRightWire);
      } else {
          // Otherwise, cut the fourth wire.
          wireArray[3].addEventListener("click", cutRightWire);
      };
  };


  function countdown(e) {
      // if (e == "new") {
		//console.log(e);
	  if (time != null) {	
		  if (time2 > 0) {
			  clearInterval(counter);
			  time2 = time;
			  counter = setInterval(function() {
				  document.querySelector("#countdown").innerHTML = `${time2}`;
				  time2 = time2 - 1;
				  if (time2 == -1) {
					  clearInterval(counter);
					  time2 = time;
				  }
			  }, 1002);
		  } else {
			  clearInterval(counter);
			  document.querySelector("#countdown").innerHTML = `--`;
			  time2 = time;
		  }
	  }
  }