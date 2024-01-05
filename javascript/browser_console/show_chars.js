// requires the following CSS to be inserted using devtools:
// .char { outline: solid 1px oklch(65% 0.21 264); }
function styleChars (node) {
  const chars = node.nodeValue;
  let result = [];
  let whitespaceCount = 0;
  let wrappedChar;
  let wrappedCharText;
  
  for (let char of chars) {
    if (char.match(/\s/) !== null) { whitespaceCount++; }
    wrappedChar = document.createElement('span');
    wrappedCharText = document.createTextNode(char);
    wrappedChar.classList.add('char');
    wrappedChar.appendChild(wrappedCharText);
    result.push(wrappedChar);
  }
  
  if (whitespaceCount !== result.length) {
    node.replaceWith(...result);
  }
}

function recurse (node) {
  const nodesToIgnore = [
    'script'
  ];
  if (!node.childNodes.length) { // leaf node
    if (node.nodeType === 3) { // text node
      if (!nodesToIgnore.includes(node.parentNode.nodeName.toLowerCase())) {
      	styleChars(node);
      }
    }
  } else {
    Array.from(node.childNodes).forEach(child => recurse(child))
  }
}

recurse(document.body);
