
"use strict";

let foc;
let massage = []
let Valid
let inputMark = false
// Return true if the input value contains only digits (at least one)
function isNumeric(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value.trim();
	var isValid = (inputValue.search(/^[0-9]+$/) !== -1);
	showMessage(isValid, inputElement, errorMsg);
}
function isValidFile(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.files[0].type
	var isValid = inputElement.accept.split(',').some(x=>x===inputValue)
	showMessage(isValid, inputElement, errorMsg);
}
function isPhoneNumber(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var isValid = /^(\+\d{1,3}( )?)?((\(\d{1,3}\))|\d{1,3})[- .]?\d{3,4}[- .]?\d{4}$/.test(inputElement.value)
	showMessage(isValid, inputElement, errorMsg);
}
// Return true if the input value is not empty
function isValidPassword(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var isValid = /(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=\S+$).{8,}/.test(inputElement.value);
	showMessage(isValid, inputElement, errorMsg);
}
function isNotEmpty(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value.trim();
	var isValid = (inputValue.length !== 0);  // boolean
	showMessage(isValid, inputElement, errorMsg);
}
function isMetchPassword(password, cPassword, errorMsg) {
	if (typeof password === "string") {
		password = document.getElementById(password);
	}
	if(typeof cPassword ==="string"){
         cPassword= document.getElementById(cPassword);
      }   
	var isValid = password.value ===cPassword.value
	showMessage(isValid, cPassword, errorMsg);
}
// Return true if the input value is empty
function isEmpty(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value.trim();
	var isValid = (inputValue.length == 0);  // boolean
	if (isValid) {
		inputElement.classList.remove("border-danger");
		inputElement.classList.add("border-success");
	} else {
		isNumeric(inputId, errorMsg)
		isLengthMinMax(inputId, errorMsg, 8, 11)
	}
}

function displaymassage() {
	let AlartMsg = ""
	for (let i = -1; i < massage.length - 1;) {
		if (massage[i] !== massage[++i])
			AlartMsg += massage[i] + "\n\n"
	}
	navigator.vibrate(100)
	if (foc) foc.focus()
	swal({
		icon: "error",
		title: "invalid input",
		text: AlartMsg
	})
}

function showMessage(isValid, inputElement, errorMsg) {

	if (!isValid) {

		massage.push(errorMsg)
		if (Valid) { foc = inputElement; Valid = false }
		// Change "class" of inputElement, so that CSS displays differently
		if (inputElement !== null) {
			inputElement.dataset.mark = inputMark
			inputElement.classList.remove("is-valid");
			inputElement.classList.add("is-invalid");
			
			// inputElement.focus();
		}
	} else {// Reset to normal display
		if (inputElement !== null && inputElement.dataset.mark !== inputMark.toString()) {
			inputElement.classList.remove("is-invalid");
			inputElement.classList.add("is-valid");

		}

	}

}


// Return true if the input value contains only letters (at least one)
function isAlphabetic(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value.trim();
	var isValid = inputValue.match(/[a-zA-Z]+$/) !== null;


	showMessage(isValid, inputElement, errorMsg);
}

// Return true if the input length is between minLength and maxLength
function isLengthMinMax(inputElement, errorMsg, minLength, maxLength) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value.trim();
	var isValid = (inputValue.length >= minLength) && (inputValue.length <= maxLength);
	showMessage(isValid, inputElement, errorMsg);
}

// Return true if the input value is a valid email address
// (For illustration only. Should use regexe in production.)
function isValidEmail(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value;
	var atPos = inputValue.indexOf("@");
	var dotPos = inputValue.lastIndexOf(".");
	var isValid = (atPos > 0) && (dotPos > atPos + 1) && (inputValue.length > dotPos + 2);
	showMessage(isValid, inputElement, errorMsg);
}

// Return true if selection is made (not default of "") in <select> input
function isSelected(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	var inputValue = inputElement.value;
	// You need to set the default value of <select>'s <option> to "".
	var isValid = inputValue !== "";
	showMessage(isValid, inputElement, errorMsg);
}

// The "onclick" handler for the "reset" button to clear the display
function clearDisplay() {
	document.querySelectorAll(".is-invalid").forEach(v=> v.classList.remove("is-invalid"))
	document.querySelectorAll(".is-valid").forEach(v=> v.classList.remove("is-valid") )
}
function isCreditCardNumber(inputElement, errorMsg) {
	if (typeof inputElement === "string") {
		inputElement = document.getElementById(inputElement);
	}
	let ints = inputElement.value.replace(/-/gi, "").split("");
	for (let i = 0; i < ints.length; i++) {
		ints[i] = parseInt(ints[i]);
	}
	for (let i = ints.length - 2; i >= 0; i = i - 2) {
		let j = ints[i];
		j = j * 2;
		if (j > 9) {
			j = j % 10 + 1;
		}
		ints[i] = j;
	}
	let sum = 0;
	for (let i = 0; i < ints.length; i++) {
		sum += ints[i];
	}
	showMessage(sum % 10 == 0, inputElement, errorMsg);
}