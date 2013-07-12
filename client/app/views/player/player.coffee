###
Here is the player with some freaking awesome features like play and pause...
###
BaseView = require '../../lib/base_view'
VolumeManager = require './volumeManager'
app = require '../../application'

module.exports = class Player extends BaseView

    className: "player"
    tagName: "div"
    template: require('../templates/player/player')

    events:
        "click .button.play": "onClickPlay"

    afterRender: =>
        initialVolume = 50 # default volume value

        # create and bind the volumeManager
        @vent = _.extend {}, Backbone.Events
        @vent.bind "volumeHasChanged", @onVolumeChange
        @vent.bind "muteHasBeenToggled", @onToggleMute
        @volumeManager = new VolumeManager({initVol: initialVolume,vent: @vent})
        @volumeManager.render()
        @$el.append @volumeManager.$el

        @currentTrack = app.soundManager.createSound
            id: "DaSound#{(Math.random()*1000).toFixed(0)}"
            url: "music/COMA - Hoooooray.mp3"
            volume: initialVolume
            onfinish: @stopTrack
            onstop: @stopTrack
        @isStopped = true
        @isPaused = false
        @playButton = @$(".button.play")
        @playButton.addClass("stopped")

    onClickPlay: ->
        if @isStopped
            @currentTrack.play()
            @playButton.removeClass("stopped")
            @isStopped = false
        else if @isPaused
            @currentTrack.play()
            @playButton.removeClass("paused")
            @isPaused = false
        else if not @isPaused and not @isStopped # <=> isPlaying
            @currentTrack.pause()
            @playButton.addClass("paused")
            @isPaused = true

    stopTrack: =>
        @playButton.addClass("stopped")
        @isStopped = true
        @playButton.removeClass("paused")
        @isPaused = false

    onVolumeChange: (volume)=>
        @currentTrack.setVolume volume

    onToggleMute: =>
        @currentTrack.toggleMute()