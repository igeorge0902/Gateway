<!DOCTYPE HTML>
<!--
	Linear by TEMPLATED
    templated.co @templatedco
    Released for free under the Creative Commons Attribution 3.0 license (templated.co/license)
-->
<html>

<head>
    <title>Linear by TEMPLATED</title>

    <meta charset="ISO-8859-1">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />

    <link href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,700,500,900' rel='stylesheet' type='text/css'>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="js/skel.min.js"></script>
    <script src="js/skel-panels.min.js"></script>
    <script src="js/init.js"></script>

    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href='css/app.css' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="css/skel-noscript.css" />
    <link rel="stylesheet" href="css/style.css" />
    <link rel="stylesheet" href="css/style-desktop.css" />

    <script type="text/javascript" src="js/angular.min.js"></script>
    <script type="text/javascript" src="js/angular-animate.js"></script>
    <script type="text/javascript" src="js/lib/aes.js"></script>
    <script type="text/javascript" src="js/lib/pbkdf2.js"></script>
    <script type="text/javascript" src="js/AesUtil.js"></script>
    <script type="text/javascript" src="js/controllers.js"></script>
    <script type="text/javascript" src="js/app.js"></script>
    <script type="text/javascript" src="js/directives.js"></script>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/ui-bootstrap-tpls-0.13.4.js"></script>
    <script type="text/javascript" src="js/modal.js"></script>

    <noscript>
        <link rel="stylesheet" href="css/skel-noscript.css" />
        <link rel="stylesheet" href="css/style.css" />
        <link rel="stylesheet" href="css/style-desktop.css" />
    </noscript>

</head>

<body class="homepage">

    <!-- Header -->
    <div id="header">
        <div id="nav-wrapper">
            <!-- Nav -->
            <nav id="nav">
                <ul>
                    <li class="active"><a href="index.html">Homepage</a></li>
                    <li><a href="left-sidebar.html">Left Sidebar</a></li>
                    <li><a href="right-sidebar.html">Right Sidebar</a></li>
                    <li><a href="no-sidebar.html">No Sidebar</a></li>
                </ul>
            </nav>
        </div>
        <div class="container">

            <!-- Logo -->
            <div id="logo">
                <h1><a href="#">Linear</a></h1>
                <span class="tag">By TEMPLATED</span>
            </div>
        </div>
    </div>

    <!-- Featured -->
    <div id="featured">
        <div class="container">
            <header>
                <h2>Welcome to Linear</h2>
            </header>
            <p>This is <strong>Linear</strong>, a responsive HTML5 site template freebie by <a href="http://templated.co">TEMPLATED</a>. Released for free under the <a href="http://templated.co/license">Creative Commons Attribution</a> license, so use it for whatever (personal or commercial) &ndash; just give us credit! Check out more of our stuff at <a href="http://templated.co">our site</a> or follow us on <a href="http://twitter.com/templatedco">Twitter</a>.</p>
            <hr />
            <!-- AngularJS -->
            <div data-ng-app="myApp">
                <div data-ng-controller="GetUser">
                    <div class="container-fluid">
                        <header>
                            <h2>
                                My Profile
                              </h2>
                        </header>
                        <div class="row">
                            <div class="col-sm-8">
                                <button class="btn btn-lg btn-primary" data-ng-click="refreshUser()">
                                    Fetch data from server
                                </button>
                                <img ng-show="isLoading()" src="images/progressring.gif" />
                                <h5>
                                    Id : {{::user.id}}
                                  </h5>
                                <h5>
                                    User name : {{::user.user}}
                                  </h5>
                            </div>
                            <div ng-controller="SearchCtrl">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <input class="form-control input-lg" placeholder="Search" ng-model="keywords" ng-change="search()" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--
                              <div class="row" ng-show="errorMessage != ''">
                                <div class="col-sm-12">
                                  <h3 class="text-danger">
                                    {{errorMessage}}
                                  </h3>
                                </div>
                              </div>
                              <div class="row" ng-show="successMessage != ''">
                                <div class="col-sm-12">
                                  <h3 class="text-success">
                                    {{successMessage}}
                                  </h3>
                                </div>
                              </div> -->

                        <script type="text/ng-template" id="myModalContent.html">
                            <div class="modal-body">
                        </script>
                        <modal title="Login form" visible="showModal">
                            <form role="form">
                                <div class="form-group">
                                    <label for="email">Email address</label>
                                    <input type="email" class="form-control" id="email" placeholder="Enter email" />
                                </div>
                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <input type="password" class="form-control" id="password" placeholder="Password" />
                                </div>
                                <button type="submit" class="btn btn-default">Submit</button>
                            </form>
                        </modal>
                        </div>
                    </div>
                    <div data-ng-controller="LogOut">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-sm-8">
                                    <button class="btn btn-lg btn-primary" data-ng-click="logOut()">
                                        Logout
                                    </button>
                                </div>
                            </div>
                            <!--
                              <div class="row" ng-show="errorMessage != ''">
                                <div class="col-sm-12">
                                  <h3 class="text-danger">
                                    {{errorMessage}}
                                  </h3>
                                </div>
                              </div>
                              <div class="row" ng-show="successMessage != ''">
                                <div class="col-sm-12">
                                  <h3 class="text-success">
                                    {{successMessage}}
                                  </h3>
                                </div>
                              </div>
                                -->
                        </div>
                    </div>

                    <div ng-controller="MainCtrl">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-sm-12">
                                    <h1>Modal example</h1>
                                    <button ng-click="toggleModal()" class="btn btn-default">Open modal</button>
                                </div>
                            </div>
                            <modal title="Login form" visible="showModal">
                                <form role="form">
                                    <div class="form-group">
                                        <label for="email">Email address</label>
                                        <input type="email" class="form-control" id="email" placeholder="Enter email" />
                                    </div>
                                    <div class="form-group">
                                        <label for="password">Password</label>
                                        <input type="password" class="form-control" id="password" placeholder="Password" />
                                    </div>
                                    <button type="submit" class="btn btn-default">Submit</button>
                                </form>
                            </modal>
                        </div>
                    </div>
                    <div ng-controller="ModalCtrl">
                        <div class="container-fluid">
                            <script type="text/ng-template" id="myModalContent.html">>
                                <div class="modal-body" />
                            </script>
                            <div class="row">
                                <div class="col-sm-12">
                                    <h1>Modal 2</h1>
                                    <button type="button" class="btn btn-default" ng-click="open()">Open me!</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
        <!-- Main -->
        <div id="main">
            <div id="content" class="container">

                <div class="row">
                    <section class="6u">
                        <a href="#" class="image full"><img src="https://milo.crabdance.com/simple-service-webapp/webapi/myresource/images/pic01.jpg" alt=""></a>
                        <header>
                            <h2>Mauris vulputate dolor</h2>
                        </header>
                        <p>In posuere eleifend odio. Quisque semper augue mattis wisi. Maecenas ligula. Pellentesque viverra vulputate enim. Aliquam erat volutpat. Donec leo, vivamus fermentum nibh in augue praesent a lacus at urna congue rutrum.</p>
                    </section>
                    <section class="6u">
                        <a href="#" class="image full"><img src="https://milo.crabdance.com/simple-service-webapp/webapi/myresource/images/pic02.jpg" alt=""></a>
                        <header>
                            <h2>Mauris vulputate dolor</h2>
                        </header>
                        <p>In posuere eleifend odio. Quisque semper augue mattis wisi. Maecenas ligula. Pellentesque viverra vulputate enim. Aliquam erat volutpat. Donec leo, vivamus fermentum nibh in augue praesent a lacus at urna congue rutrum.</p>
                    </section>
                </div>
                <div class="row">
                    <section class="6u">
                        <header>
                            <h2>Budapest</h2>
                        </header>
                        <a href="#" class="image full"><img src="https://milo.crabdance.com/simple-service-webapp/webapi/myresource/images/Bp-1.jpg" alt=""></a>
                    </section>
                </div>
                <div class="row">
                    <section class="6u">
                        <a href="#" class="image full"><img src="https://milo.crabdance.com/simple-service-webapp/webapi/myresource/images/pic03.jpg" alt=""></a>
                        <header>
                            <h2>Mauris vulputate dolor</h2>
                        </header>
                        <p>In posuere eleifend odio. Quisque semper augue mattis wisi. Maecenas ligula. Pellentesque viverra vulputate enim. Aliquam erat volutpat. Donec leo, vivamus fermentum nibh in augue praesent a lacus at urna congue rutrum.</p>
                    </section>
                    <section class="6u">
                        <a href="#" class="image full"><img src="https://milo.crabdance.com/simple-service-webapp/webapi/myresource/images/pic04.jpg" alt=""></a>
                        <header>
                            <h2>Mauris vulputate dolor</h2>
                        </header>
                        <p>In posuere eleifend odio. Quisque semper augue mattis wisi. Maecenas ligula. Pellentesque viverra vulputate enim. Aliquam erat volutpat. Donec leo, vivamus fermentum nibh in augue praesent a lacus at urna congue rutrum.</p>
                    </section>
                </div>

            </div>
        </div>

        <!-- Tweet -->
        <div id="tweet">
            <div class="container">
                <section>
                    <blockquote>&ldquo;In posuere eleifend odio. Quisque semper augue mattis wisi. Maecenas ligula. Pellentesque viverra vulputate enim. Aliquam erat volutpat.&rdquo;</blockquote>
                </section>
            </div>
        </div>

        <!-- Footer -->
        <div id="footer">
            <div class="container">
                <section>
                    <header>
                        <h2>Get in touch</h2>
                        <span class="byline">Integer sit amet pede vel arcu aliquet pretium</span>
                    </header>
                    <ul class="contact">
                        <li><a href="#" class="fa fa-twitter"><span>Twitter</span></a></li>
                        <li class="active"><a href="#" class="fa fa-facebook"><span>Facebook</span></a></li>
                        <li><a href="#" class="fa fa-dribbble"><span>Pinterest</span></a></li>
                        <li><a href="#" class="fa fa-tumblr"><span>Google+</span></a></li>
                    </ul>
                </section>
            </div>
        </div>

        <!-- Copyright -->
        <div id="copyright">
            <div class="container">
                Design: <a href="http://templated.co">TEMPLATED</a> Images: <a href="http://unsplash.com">Unsplash</a> (<a href="http://unsplash.com/cc0">CC0</a>)
            </div>
        </div>

</body>

</html>