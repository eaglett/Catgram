# Catgram

Catgram is a social network specialised in Cat images. Only images that contain a cat can be uploaded. The project is written in Swift and implements Firebase Firestore, Storage and Authentication, it also uses Apple Vision.

First you need to log in or create an account. If your input is invalid a banner will be shown. For this feature I used [NotificationBannerSwift](http://cocoadocs.org/docsets/NotificationBannerSwift/1.0.1/).

![CreateAccount](https://github.com/eaglett/Catgram/blob/master/Images/CreateAccount.png?raw=true)

Once you are logged in, the feed is shown. Feed consists of randomly choosen images from the storage. If you want to see more images, you need to refresh the feed. Feed refreshing can be executed by clicking on a button in top left corner or shaking the device.

You can also click on a image in the feed and it will open in single image view. Here you can see how many likes an image has an like/unlike it yourself.

![Feed](https://github.com/eaglett/Catgram/blob/master/Images/Feed.png?raw=true)

In the bottom of the screen we have a Tab Bar Navigator, when we click on 'Camera' we are asked if we want to upload or capture an image. When we choose an image the Vision analyses it and determines if there is a cat on the image. If there is no cat, banner will be show with the error message.

Once we have choosen the right image we have to edit it so it is square shaped. In the end we see post preview and then we can finally publish it.

![Camera](https://github.com/eaglett/Catgram/blob/master/Images/Camera.png?raw=true)

We can also open our profile page where we can see our username, profile image and all other images that we have uploaded. When we click on an image we can again see it in the single image view. If we press and hold on a cell we will be prompted if we want to delete the image.

![ProfilePage](https://github.com/eaglett/Catgram/blob/master/Images/ProfilePage.png?raw=true)

We can also edit our profile. After clicking on a button under our username, a separate view will be shown were we can change username, phone number, request password change and upload our profile image.

If we request password change, an email will be sent to us with a link to a webpage where we can reset our password.

![EditProfilePage](https://github.com/eaglett/Catgram/blob/master/Images/EditProfilePage.png?raw=true)
