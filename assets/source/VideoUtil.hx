import hxvlc.flixel.FlxVideoSprite;
import flixel.util.FlxArrayUtil;

// if this isnt bullshit i dont know what is -myra

/**
 * Custom Class used for preloading and playing videos into Playstate, and possibly other states. Built by m0chimyra (@joemfunni).
 */
class VideoUtil {
	public var videoList:Array<FlxVideoSprite> = [];
	public static var curVideo:FlxVideoSprite;

	/**
	 * Pause & resume functions. Self-explanatory.
	 */
	public function pauseCur() { if (curVideo != null) curVideo.pause(); }
	public function resumeCur() { if (curVideo != null) curVideo.resume(); }

	/**
	 * Preloads an array of videos by path and sets the camera they will be placed on.
	 * @param paths 			An array of videos to be loaded. Will look something like ["vid1", "vid2"].
	 * @param options 		An array of options set for your video (e.g., [:no-audio]). For more info, you can look at https://wiki.videolan.org/VLC_command-line_help/
	 * @param camera 		The camera your video will be placed into.
	 * @param dynamic 	Determines whether or not the video is a dynamic video (i.e., is it adjustable?)
	 */
	public function load(paths:Array<String>, options:Array<String>, camera:FlxCamera, ?dynamic:Bool = false):Void {
		var dynamic = dynamic;
		var paths = paths;

		for (vid in paths) {
			var camera = camera;
			var options = options;
			var loop:Bool = false;

			var video:FlxVideoSprite = new FlxVideoSprite();
			video.camera = camera;
			video.bitmap.onFormatSetup.add(function() {
				if (!dynamic) {
					video.setGraphicSize(Std.int(camera.width), camera.height);
					video.updateHitbox();
					CoolUtil.cameraCenter(video, camera);
				}
			});

			videoList.push(video);

			video.bitmap.precache(Paths.video(vid), options);
			video?.bitmap?.time = 0;
			trace("Loaded Video: " + vid);

			video.bitmap.onEndReached.add(function() {
				destroyCur();
			});
		}
	}

	/**
	 * Preloads an array of videos by url and sets the camera they will be placed on.
	 * Note that you cannot use YouTube or Twitter links, only direct links (like Discord video embeds) are supported.
	 * @param urls 				An array of videos to be loaded. Will look something like ["vid1", "vid2"].
	 * @param options 		An array of options set for your video (e.g., [:no-audio]). For more info, you can look at https://wiki.videolan.org/VLC_command-line_help/
	 * @param camera 		The camera your video will be placed into.
	 * @param dynamic 	Determines whether or not the video is a dynamic video (i.e., is it adjustable?)
	 */
	public function loadFromUrl(links:Array<String>, options:Array<String>, camera:FlxCamera, ?dynamic:Bool = false):Void {
		var dynamic = dynamic;
		var links = links;

		for (url in links) {
			var camera = camera;
			var options = options;

			var video:FlxVideoSprite = new FlxVideoSprite();
			video.load(url, options);
			video.camera = camera;
			video.bitmap.onFormatSetup.add(function() {
				if (!dynamic) {
					video.setGraphicSize(Std.int(camera.width), camera.height);
					video.updateHitbox();
					CoolUtil.cameraCenter(video, camera);
				}
			});

			videoList.push(video);

			if (video != null && video.bitmap != null) {
				video.play();
				video.pause();
				video?.bitmap?.time = 0;
				trace("Loaded Video From URL: " + url);
			}

			video.bitmap.onEndReached.add(function() {
				destroyCur();
			});
		}
	}

	/**
	 * Change the selected video's position. Only works if the video is dynamic!
	 * @param tag 		The specified video's array position.
	 * @param posX		The video's set x position.
	 * @param posY		The video's set y position.
	 */
	public function setVideoPosition(tag:Int = 0, posX:Float = 0, posY:Float = 0) {
		var video:FlxVideoSprite = videoList[tag];
		video?.setPosition(posX, posY);
	}

	/**
	 * Change the selected video's scale. Only works if the video is dynamic!
	 * @param tag 		The specified video's array position.
	 * @param scX		The video's set x scale.
	 * @param scY		The video's set y scale.
	 */
	public function setVideoScale(tag:Int = 0, scX:Float = 0, scY:Float = 0) {
		var video:FlxVideoSprite = videoList[tag];
		video?.scale.set(scX, scY);
		video?.updateHitbox();
	}

	/**
	 * Change the selected video's graphic size. Only works if the video is dynamic!
	 * @param tag 	The specified video's array position.
	 * @param gX		The video's set width.
	 * @param gY		The video's set height.
	 */
	public function setVideoGraphicSize(tag:Int = 0, gX:Int = 0, gY:Int = 0) {
		var video:FlxVideoSprite = videoList[tag];
		video?.setGraphicSize(gX, gY);
		video?.updateHitbox();
	}

	/**
	 * Plays the next video in the videoList array.
	 * @param insert 		The position it will be inserted into, will add to top if null.
	 */
	public function playNext(?insert:Int) {
		curVideo = videoList[0];
		if (FlxG.state != null) {
			if (insert != null) FlxG.state.insert(insert, curVideo);
			else FlxG.state.add(curVideo);
		}
		curVideo.play();
		trace("Played Video");
	}

	/**
	 * Swaps a specific video in the videoList with the first video in the list using their array positions, then plays the video.
	 * @param tag			The specified video to be swapped.
	 * @param insert 		Decides whether or not the video will go above or below everything in the selected camera.
	 */
	public function playSwap(tag:Int, ?insert:Int) {
		var rag = tag; // im fucking hilarious
		prevVideo = videoList[0];
		swapVideo = videoList[rag];
		FlxArrayUtil.safeSwap(videoList, prevVideo, swapVideo);
		if (insert != null) playNext(insert); else playNext();
	}

	/**
	 * Destroys the current video in the videoList array.
	 * Only call if you want the video to end in the middle of playing, as this is already automatically called when onEndReached is run.
	 */
	public function destroyCur() {
		if (curVideo != null && curVideo.bitmap != null) {
			curVideo.stop();
			curVideo.bitmap.dispose();
			if (FlxG.state != null) FlxG.state.remove(curVideo, true);
		}
		curVideo = null;
		videoList.shift();
		trace("Ended Video");
	}

	/**
	 * Clears the videoList.
	 */
	public function clearList() {
		for (vids in videoList){
			if (vids != null && vids.bitmap != null) {
				vids.bitmap.dispose();
				if (FlxG.state != null) FlxG.state.remove(vids, true);
			}
		}
		videoList.resize(0);
	}
}
