class EmbedTool extends ContentTools.Tools.Bold

    # Insert/Remove a <time> tag.

    # Register the tool with the toolshelf
    ContentTools.ToolShelf.stow(@, 'embed')

    # The tooltip and icon modifier CSS class for the tool
    @label = 'Embed'
    @icon = 'terminal'

    # The Bold provides a tagName attribute we can override to make inheriting
    # from the class cleaner.
    @tagName = 'embed'

    @canApply: (element, selection) ->
        # Return true if the tool can be applied to the current
        # element/selection.
        return true
    
    @apply: (element, selection, callback) ->

        # If supported allow store the state for restoring once the dialog is
        # cancelled.
        if element.storeState
            element.storeState()

        # Set-up the dialog
        app = ContentTools.EditorApp.get()

        # Modal
        modal = new ContentTools.ModalUI()

        # Dialog
        dialog = new ContentTools.EmbedDialog()

        # Support cancelling the dialog
        dialog.bind 'cancel', () =>
            dialog.unbind('cancel')

            modal.hide()
            dialog.hide()

            if element.restoreState
                element.restoreState()

            callback(false)

        # Support saving the dialog
        dialog.bind 'save', (videoURL) =>
            dialog.unbind('save')

            if videoURL
                # Create the new video
                video = new ContentEdit.Video(
                    'iframe', {
                        'frameborder': 0,
                        'height': ContentTools.DEFAULT_VIDEO_HEIGHT,
                        'src': videoURL,
                        'width': ContentTools.DEFAULT_VIDEO_WIDTH
                        })

                # Find insert position
                [node, index] = @_insertAt(element)
                node.parent().attach(video, index)

                # Focus the new video
                video.focus()

            else
                # Nothing to do restore state
                if element.restoreState
                    element.restoreState()

            modal.hide()
            dialog.hide()

            callback(videoURL != '')

        # Show the dialog
        app.attach(modal)
        app.attach(dialog)
        modal.show()
        dialog.show()





ContentTools.DEFAULT_TOOLS[2].push('embed')