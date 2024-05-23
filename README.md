# AgoraRTMTutorials

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Bac1314/APIExample_AgoraRTM2x">
    <!-- <img src="images/logo.png" alt="Logo" width="80" height="80"> -->
  </a>

<h3 align="center">Agora Real-time Messaging (RTM) SDK APIExample</h3>


  <p align="center">
    <a href="https://docs.agora.io/en/signaling/reference/api?platform=ios"><strong>Explore the API Reference »</strong></a>

  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

### NOTE: This project is still ongoing. Not all tutorials are finsihed

<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

A list of tutorials on how to build a contact/messaging app with Agora Signaling SDK aka Agora RTM

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* Swift & SwiftUI
* Agora RTM SDK 2.x.x (aka Signaling SDK)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started


### Prerequisites

* Xcode 13.0+
* Physical iOS device (iPhone or iPad) or simulators


### Installation

1. Create an Agora account and enable the Signaling/RTM product [https://docs.agora.io/en/signaling/get-started/beginners-guide?platform=ios]
2. Enable the Storage Configuration (Storage, User attribute callback, Channel attribute callback, and Distributed Lock)
3. Clone this repo to your local machine 
   ```
   git clone https://github.com/Bac1314/AgoraRTMTutorials.git
   ```
4. Import the RTM SDK for each tutorial (By default, it should be included in each tutorial)
   ```
   ### Option 0 - Import the framework from the  0_Libraries###
   
   ### Option 1 - Through CDN option ###
   Download the RTM framework, then drag and drop it to your project
   https://api-ref.agora.io/en/signaling-sdk/ios/2.x/index.html

   ### Option 2 - Through Cocoapods 
   pod 'AgoraRtm_iOS' --> Add this to your pod file
 
   pod install
   ```
5. Enter your API in `Configurations.swift` file
   ```swift
   static let agora_AppdID: String = "Agora App ID"
   ```


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

The list of samples and what feature is used


| **Samples**      | **Description**                                                                                      | **Status** | **RTM Features**  |
|------------------|------------------------------------------------------------------------------------------------------|---------------------|-------------------|
| [Tutorial 1](/1%20How%20to%20login%20to%20RTM%20and%20use%20PRESENCE%20to%20check%20user%20online%20status/) | How to login to RTM and user Presence to check user online              | Done | `.message`, `.presence` |
| [Tutorial 2](/2%20How%20to%20use%20USER%20METADATA%20to%20save%20friend%20list/)    |  How to use USER METADATA to save friend list | Done |  `.message`, `.presence`,  `.usermetadata`                 |
| [Tutorial 3](/3%20How%20to%20send%20direct%20message/)    |  How to send direct message                   | Done  | `.message`, `.presence`,  `.usermetadata`          |
| [Tutorial 4](/4%20How%20to%20send%20emojis/)    |  How to send emojis                           | Ongoing | `.message`, `.presence`,  `.usermetadata`          |
| [Tutorial 5](/5%20How%20to%20send%20audio%20message/)    |  How to send audio message                    | Pending | `.message`, `.presence`,  `.usermetadata`          |
| [Tutorial 6](/6%20How%20to%20use%20RTM%20for%20video%20calls%20/)    |  How to use RTM for video calls               | Pending | `.message`, `.presence`,  `.usermetadata`                     |
| [Tutorial 7](/7%20How%20to%20build%20group%20messaging%20/)    |  How to build group messaging                 | Pending | `.message`, `.presence`,  `.usermetadata`           |
| [Tutorial 8](/8%20How%20to%20use%20CHANNEL%20METADATA%20to%20post%20notice/)    |  How to use CHANNEL METADATA to post notice                 | Pending | `.message`, `.presence`,  `.usermetadata`           |

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- RTM API Limitation -->
## References

- API Reference (https://docs.agora.io/en/signaling/reference/api?platform=ios)
- Pricing (https://docs.agora.io/en/signaling/overview/pricing?platform=ios)
- API Limitations (https://docs.agora.io/en/signaling/reference/limitations?platform=android)
- Security/Compliance (https://docs.agora.io/en/signaling/reference/security?platform=android) 



<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Bac Huang  - bac@boldbright.studio

Project Link: [https://github.com/Bac1314/APIExample_AgoraRTM2x](https://github.com/Bac1314/APIExample_AgoraRTM2x)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



