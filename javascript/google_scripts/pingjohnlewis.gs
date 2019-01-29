// To use, uncomment this block and change all the values to your own.
//
// var url = 'https://www.johnlewis.com/john-lewis-partners-marble-run-game/p1399227';
// var product = '75111906';
// var emailAddress = 'me@hotmail.com';

// methods
function getHTML(url) {
  Logger.log("requesting " + url);
  var response = UrlFetchApp.fetch(url);
  
  return response.getContentText();
}

function sendEmail(product, isAvailable) {
  var timeDate = new Date();
  var availability = (isAvailable ? "in stock" : "out of stock");
  var subject = "Availability of " + product + " - " + availability;
  var message = [
    product + " is currently " + availability,
    "Website checked: " + timeDate
  ].join("\n");
  
  Logger.log("Sending to " + emailAddress + ", subject: '" + subject + "', message: '" + message);
  
  MailApp.sendEmail(emailAddress, subject, message);
};

function pingJohnLewis() {
  var html;
  var outOfStockButton;
  
  html = getHTML(url);
  outOfStockButton = html.match(/<button[a-zA-Z\s"=\-_]+button--add-to-basket-out-of-stock[a-zA-Z\s"=\-_]+>/);
  
  if (outOfStockButton !== null) {
    Logger.log('Button found: ' + outOfStockButton[0]);
    Logger.log("Sending an email saying it's out of stock");
    sendEmail(product, false);
  } else {
    Logger.log('Button not found');
    Logger.log("Sending an email saying it's in stock");
    sendEmail(product, true);
  }
}
