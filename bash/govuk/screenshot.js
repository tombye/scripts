var casper,
    viewports = {
      'desktop': { 'width': 1024, 'height': 768 },
      'tablet': { 'width': 768, 'height': 1024 },
      'mobile': { 'width': 320, 'height': 480 }
    },
    baseDir = '/Users/tombyers/Documents/casperjs_screenshots/',
    baseUrl = 'http://ier.dev.gov.uk:9000/',
    pages = {
      'nationality': {
        'url': 'register-to-vote/nationality',
        'interactions': {
          'page validation': {
            'action': function() {
              this.click('button#continue');
            },
            'pause': 2000,
            'capture': true
          },
          'refresh page 1': {
            'action': function() {
              this.reload();
            },
            'pause': 2000,
            'capture': false
          },
          'click is citizen of other country': {
            'action': function() {
              this.click('#nationality_hasOtherCountry');
            },
            'pause': 1000,
            'capture': true
          },
          'click add another country': {
            'action': function() {
              this.click('a.duplicate-control-initial');
            },
            'pause': 1000,
            'capture': true
          },
          'click to add a 2nd other country': {
            'action': function() {
              this.click('a.duplicate-control-initial');
            },
            'pause': 1000,
            'capture': true
          },
          'click help with other countries added': {
            'action': function() {
              this.clickLabel('Help');
            },
            'pause': 1000,
            'capture': true
          },
          'click I cant provide my nationality with other countries added': {
            'action': function() {
              this.click('div.help-content a.toggle');
            },
            'pause': 1000,
            'capture': true
          },
          'refresh page 2': {
            'action': function() {
              this.reload();
            },
            'pause': 2000,
            'capture': false
          },
          'click help': {
            'action': function() {
              this.clickLabel('Help');
            },
            'pause': 1000,
            'capture': true
          },
          'click I cant provide my nationality': {
            'action': function() {
              this.click('div.help-content a.toggle');
            },
            'pause': 1000,
            'capture': true
          }
        }
      }
    },
    captureAll,
    interactions;

captureAll = function (page, interaction) {
  var size;

  for (size in viewports) {
    var interaction = (interaction ? interaction.replace(/\s/g, '-') : 'default'),
        width = viewports[size].width,
        height = viewports[size].height,
        pageHeight = this.getElementBounds('body');

    if (pageHeight !== null) { height = pageHeight.height; }
    this.viewport(width, height);
    //this.echo('capturing ' + size + ' screenshot of ' + interaction + ', saving to: ' + baseDir + page + '-' +  interaction + '.' + size + '.png');
    try {
      this.capture(baseDir + page + '-' +  interaction + '.' + size + '.png', {
        "top": 0,
        "left": 0,
        "width": width,
        "height": height
      });
    } catch (e) {
      this.echo('capture failed with error of ' + e.message);
    }
  }
};

casper = require('casper').create({
  viewportSize: viewports.desktop
});

casper.start(baseUrl);
casper.then(function () {
  var pause,
      interactions,
      interactionNames,
      runInteraction,
      currentInteraction = 0;

  runInteraction = function(interactions, interactionNames, page) {
    var name = interactionNames[currentInteraction],
        pause = interactions[name].pause;

    this.echo("capturing '" + name + "' interaction");
    interactions[name].action.call(this);
    if (pause) {
      this.wait(pause, function () { 
        if (interactions[name].capture) {
          captureAll.apply(this, [page, name]);
        }
        currentInteraction++;
        if (currentInteraction < interactionNames.length) {
          runInteraction.apply(this, [interactions, interactionNames, page]);
        }
      });
    } else {
      this.echo('not pausing before interaction');
      if (interactions[name].capture) {
        captureAll.apply(this, [page, name]);
      }
      currentInteraction++;
      if (currentInteraction < interactionNames.length) {
        runInteraction.apply(this, [interactions, interactionNames, page]);
      }
    }
  };

  this.echo('******* capturing the start page *******');
  captureAll.apply(this, ['start', 'default']);
  this.click('#get-started a.button');
  this.wait(1000, function() {

    for (page in pages) {
      this.echo('');
      this.echo('****** capturing the ' + page + ' page *******');
      this.echo('');
      interactions = pages[page].interactions;
      interactionNames = [];

      captureAll.apply(this, [page, 'default']);
      casper.then(function () {
        for (interaction in interactions) {
          interactionNames.push(interaction);
        }
        runInteraction.apply(this, [interactions, interactionNames, page]); 
      });
    }

  });
});
casper.run();
