# Catgram

Catgram is a social network specialised in Cat images. Only images that contain a cat can be uploaded. The project is written in Swift and implements Firebase Firestore, Storage and Authentication, it also uses Apple Vision.

First you need to log in or create an account. If your input is invalid a banner will be shown. For this feature I used [NotificationBannerSwift](http://cocoadocs.org/docsets/NotificationBannerSwift/1.0.1/).

![CreateAccount](https://github.com/eaglett/Catgram/blob/master/Images/CreateAccount.png?raw=true)

Once you are logged in, the feed is shown. Feed consists of randomly choosen images from the storage. If you want to see more images, you need to refresh the feed. Feed refreshing can be executed by clicking on a button in top left corner or shaking the device.

You can also click on a image in the feed and it will open in single image view. Here you can see how many likes an image has an like/unlike it yourself.

![Feed](https://github.com/eaglett/Catgram/blob/master/Images/Feed.png?raw=true)
