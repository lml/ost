# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ () ->
  feedbackRequired = $ ".field.feedback-required input"
  feedbackRequired.click () ->
    feedbackPenalty = $ ".field.feedback-viewing-penalty"
    feedbackPenaltyValue = feedbackPenalty.find "input"
    if feedbackRequired.is ':checked'
      feedbackPenaltyValue.val "100"
      feedbackPenalty.show()
    else
      feedbackPenaltyValue.val null
      feedbackPenalty.hide()
