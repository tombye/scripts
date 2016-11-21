function checkThreads() {
  var threads = GmailApp.getInboxThreads(0, 300),
      maxDays = 14;
  
  Logger.log('Total number of threads in the range 300 - 500 is ' + threads.length);
};

function getThreadLabelNames(threadLabels) {
  var labelNames = [],
      i,
      len = threadLabels.length;

  for (i = 0; i < len; i++) {
    labelNames.push(threadLabels[i].getName());
  }
  return labelNames;
};

function threadHasOneOfTheseLabels(thread, labels) {
  var threadLabelNames,
      i,
      hasLabel,
      labelsLength;

  for (i = 0, labelsLength = labels.length; i < labelsLength; i++) {
    threadLabelNames = getThreadLabelNames(thread.getLabels());
    hasLabel = threadLabelNames.indexOf(labels[i]) !== -1;
    if (hasLabel) {
      return true;
    }
  }
  return false;
};

function getThreadsWithTheseLabels(threads, labels, maxDays, range) {
  var total = [],
      daysOld;
  
  Logger.log('Checking ' + threads.length + ' threads against the following labels: ' + labels.join(','));
  for (var i = 0, j = threads.length; i < j; i++) {
    threadLabels = threads[i].getLabels();
    if (threadLabels && threadLabels.length) {
      daysOld = getDaysOld(threads[i]);
      Logger.log("Checking thread which is " + daysOld + " days old, and has following labels: '" + getThreadLabelNames(threadLabels).join(', ') + "'");
      hasLabel = threadHasOneOfTheseLabels(threads[i], labels);
      if (hasLabel && (daysOld > maxDays)) {
        total.push(threads[i]);
      }
    }
  }
  Logger.log("Number of threads with one of the labels '" + labels.join(', ') + "' in the range " + range + ":");
  Logger.log(total.length);
  
  return total;
}

function deleteThreads(threads) {
  var i,
      len = threads.length;

  for (i = 0; i < len; i++) {
    Logger.log("Thread with subject of '" + threads[i].getFirstMessageSubject() + "' moved to trash");
    threads[i].moveToTrash();
  }
};

var getDaysOld = (function() {
  var now = (new Date()).getTime();
  return function(thread) {
    var age = thread.getLastMessageDate().getTime(),
        daysOld = Math.floor((((((now - age) / 1000) / 60) / 60) / 24));
    
    return daysOld;
  }
}())

function getIndexesOfThreadsWithLabels(threads, maxDays, range) {
  var total = [],
      daysOld;
  
  for (var i = 0, j = threads.length; i < j; i++) {
    threadLabels = threads[i].getLabels();
    if (threadLabels && threadLabels.length) {
      daysOld = getDaysOld(threads[i])
      if (daysOld > maxDays) {
        total.push(i);
      }
    }
  }
  Logger.log('Number of labelled threads in the range ' + range + ':');
  Logger.log(total.length);
  
  return total;
}

function archiveLabelled(threads, indexesOfThreadsWithLabels, maxDays) {
  var threadLabels,
      idx,
      age,
      daysOld,
      labelStr;
  
for (i = 0, j = indexesOfThreadsWithLabels.length; i < j; i++) {
    idx = indexesOfThreadsWithLabels[i];
    threadLabels = threads[idx].getLabels();
    if (threadLabels && threadLabels.length) {
      age = threads[idx].getLastMessageDate().getTime();
      daysOld = getDaysOld(threads[idx]);
      if (daysOld > maxDays) {
        threads[idx].moveToArchive();
        labelStr = '';
        for (var a = 0, b = threadLabels.length; a < b; a++) {
          labelStr += threadLabels[a].getName() + ', ';
        }
        Logger.log('Thread with labels: "' + labelStr.replace(/(,\s){1}$/, '') + '", which was ' + daysOld + ' days old and ' + idx + ' in those left, now archived');
      }
    }
  }
}

function archiveOldLabelled() {
  var ranges = [[300, 500], [0, 300]],
      rangeIdx = 0,
      threads,
      maxDays = 14,
      tolerance = 20,
      done = false,
      threadLabels,
      indexesOfThreadsWithLabels,
      processThreads;
  
  Logger.log('Running at : ' + (new Date()));
  
  processThreads = function () {
    threads = GmailApp.getInboxThreads(ranges[rangeIdx][0], ranges[rangeIdx][1]); 
    Logger.log('Total number of threads in the range ' + ranges[rangeIdx][0] + '-' + ranges[rangeIdx][1] + ' is ' + threads.length);
    indexesOfThreadsWithLabels = getIndexesOfThreadsWithLabels(threads, maxDays, ranges[rangeIdx][0] + '-' + ranges[rangeIdx][1]);
    Logger.log('Total threads left with labels is ' + indexesOfThreadsWithLabels.length);
    archiveLabelled(threads, indexesOfThreadsWithLabels, maxDays);
    rangeIdx++;
    if (rangeIdx === ranges.length) { return; }
    if (indexesOfThreadsWithLabels.length < tolerance) { processThreads(); }
  }
  processThreads();
};

var ThreadsBatch = function (opt) {
  this.callback = opt.callback;
  this.ranges = opt.ranges;
};
ThreadsBatch.prototype.run = function () {
  var ranges = this.ranges,
      threads,
      i;

  for (i = 0, numOfRanges = this.ranges.length; i < numOfRanges; i++) {
    threads = GmailApp.getInboxThreads(ranges[i][0], ranges[i][1]);    
    Logger.log("Number of threads in the range " + ranges[i][0] + '-' + ranges[i][1] + ": " + threads.length);
    this.callback(threads, ranges[i][0] + '-' + ranges[i][1]);
  }
};

function deleteThreadsWithTheseLabels(opts) {
  var labels = opts.labels,
      maxDays = opts.maxDays,
      callback;

  var callback = function (threads, range) {
    var threadsWithGithubLabels = getThreadsWithTheseLabels(threads, labels, maxDays, range)

    deleteThreads(threadsWithGithubLabels);
  };

  var threadsBatch = new ThreadsBatch({
    "ranges" : [[0, 500]],
    "callback" : callback
  });
  threadsBatch.run();
};

function deleteThreadsWithGithubLabels() {
  deleteThreadsWithTheseLabels({ labels : ['github'], maxDays : 7 });
};

function deleteThreadsWithTwitterFacebookLabels() {
  deleteThreadsWithTheseLabels({ labels : ['Twitter', 'facebook'], maxDays : 7 });
};

function clearLog() {
  Logger.log('Clear log');
}
