<!doctype html>
<!--
/*******************************************************************************
* Copyright (c) 2016, WSO2.Telco Inc. (http://www.wso2telco.com)
*
* All Rights Reserved. WSO2.Telco Inc. licences this file to youunder the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
******************************************************************************/
-->
<%@page import="java.util.logging.Logger" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.framework.cache.*" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.framework.context.*" %>
<%@ page import="com.wso2telco.identity.application.authentication.endpoint.util.DbUtil" %>
<%@ page import="java.util.HashMap" %>
<html class="site no-js lang--en" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Mobile Connect</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">

    <link rel="apple-touch-icon" href="apple-touch-icon.png">
    <script src="mcx-user-registration/js/jquery-3.2.1.min.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/landing.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/tether.min.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/public/js/main.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/public/js/modal.js" type="text/javascript"></script>
    <script src="mcx-user-registration/js/parsley.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="mcx-user-registration/mcresources/css/style.css">
    <link rel="stylesheet" href="mcx-user-registration/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">


    <noscript>
        <!-- Fallback synchronous download, halt page rendering if load is slow  -->
        <link href="//fonts.googleapis.com/css?family=Roboto:400,300,700,400italic,300italic,700italic" rel="stylesheet"
              type="text/css">
    </noscript>
    <!-- loads fonts asyncronously preventing font loading from block page render -->
    <script>
        // Config for loading the web fonts
        var WebFontConfig = {
            google: {
                families: ['Roboto:400,300,700,400italic,300italic,700italic']
            },
            active: function () {
                // Set a cookie that the font has been downloaded and should be cached
                var d = new Date();
                d.setTime(d.getTime() + (7 * 86400000)); // plus 7 Days
                document.cookie = "cachedroboto=true; expires=" + d.toGMTString() + "; path=/";
            }
        };
    </script>
    <script src="mcx-user-registration/mcresources/js/vendor/webfontloader.js"></script>
    <!-- Adds IE root class without breaking doctype -->
    <!--[if IE]>
    <script>document.documentElement.className = document.documentElement.className + " ie";</script>
    <![endif]-->

    <!-- load main script early asyncronously -->
    <script type="text/javascript" src="mcx-user-registration/mcresources/js/main.js" async></script>
    <script type="text/javascript" src="mcx-user-registration/mcresources/js/vendor/modernizr.js"></script>

    <%
	    Logger log=Logger.getLogger(this.getClass().getName());
        String id = request.getParameter("id");
        Boolean isRegistering = Boolean.valueOf(request.getParameter("registering"));
        String operator = "";
        boolean isSessionExpired = DbUtil.getSessionStatus(id);
        Map<String,String> scopeDescription = null;
        String spLogo =null;
        String spName = null;
        String appName = null;
        boolean approve_all_enable = false;

        if(!isSessionExpired){
            scopeDescription= DbUtil.getScopeDescforSession(id);
            if(scopeDescription.isEmpty()){
                isSessionExpired = true;
            }else{
                isRegistering = Boolean.valueOf(scopeDescription.get("isNewUser"));
                operator = scopeDescription.get("operator");
                spName = scopeDescription.get("spName");
                appName = spName;
                approve_all_enable = Boolean.valueOf(scopeDescription.get("approve_all_enable"));
                scopeDescription.remove("isNewUser");
                scopeDescription.remove("operator");
                scopeDescription.remove("spName");
                scopeDescription.remove("approve_all_enable");
                if(spName.contains("PRODUCTION")){
                    spName = spName.split("_")[1];
                }
            }
        }

/*
        String sessionDataKey = DbUtil.getContextIDForHashKey(id);
	    AuthenticationContextCacheKey cacheKey = new AuthenticationContextCacheKey(sessionDataKey);
	    Object cacheEntryObj = AuthenticationContextCache.getInstance().getValueFromCache(cacheKey);
	    AuthenticationContext authnContext = null;
		if (cacheEntryObj != null) {
			authnContext = ((AuthenticationContextCacheEntry) cacheEntryObj).getContext();
		}

        String spLogo =null;
        String operator=null;
        String spName=null;
        boolean approve_all_enable = false;
        Map<String,String> scopeDescription= new HashMap<String,String>();

        boolean isSessionExpired = false;
        if(authnContext!=null){
            operator = authnContext.getProperty("operator").toString();
            spName = authnContext.getServiceProviderName();
            approve_all_enable=Boolean.valueOf(String.valueOf(authnContext.getProperty("approve_all_enable")));
            scopeDescription= (Map<String, String>)authnContext.getProperty("approve_needed_scopes");
            isRegistering=Boolean.valueOf(String.valueOf(authnContext.getProperty("isRegistering")));
            if(authnContext.getProperty("logo")!=null){
                spLogo = authnContext.getProperty("logo").toString();
            }
        } else {
            isSessionExpired = true;
        }
*/

        String imgPath = null;
        String termsConditionsPath = null;
        if (operator!=null && !operator.isEmpty()) {
            imgPath = "images/branding/" + operator + "_logo.png";
            termsConditionsPath = "html/terms-conditions/" + operator + "-terms-conditions.html";
    %>
    <link href="css/branding/<%=operator%>-style.css" rel="stylesheet">
    <%
        }
    %>

</head>

<body class="theme--light">
    <div class="site__root">
        <header class="site-header">
            <div class="site-header__inner site__wrap">
                <h1 class="visuallyhidden">Mobile Connect</h1>
                <a href="/"><img src="mcx-user-registration/mcresources/img/svg/mobile-connect.svg" alt="Mobile Connect&nbsp;Logo" width="150"
                                 class="site-header__logo"></a>
                <% if (!isSessionExpired) { %>
                    <p class="site-header__powered-by">powered by
                        <img src='<%=imgPath%>' alt="Operator" class="brandLogo">
                    </p>
                <% } %>
            </div>
        </header>

        <% if (isSessionExpired) { %>
            <main class="site__main site__wrap section v-distribute v-grow">
                <div class="grid">
                     <div class="grid__item three-quarters">
                        <h2 class="page__heading">Session Expired</h2>
                        <p>Looks like your authentication session is expired. Please try again.</p>
                     </div>
                </div>
            </main>
        <% } else { %>
            <main class="site__main site__wrap section v-distribute v-grow">
                    <div class="grid">
                        <%
                        if(!(spLogo == null || "".equals(spLogo))){
                        %>
                             <div class="grid__item one-quarter">
                                 <img src='<%=spLogo%>' alt="App logo" width="100">
                             </div>
                       <% }
                       %>
                         <div class="grid__item three-quarters">
                            <h2 class="page__heading"><%=spName%></h2>
                            <p>You are granting <b><%=appName%></b> the rights to access the following</p>
                         </div>
                    </div>

                <header class="page__header" id="ussdpin_update_header" style="display:none">
                    <h1 class="page__heading">Looks like you have to update your account, let’s make your
                        account&nbsp;secure</h1>
                    <p>Create a PIN for secure log-in and two questions we can ask you in case you ever forget
                        your&nbsp;PIN.</p>
                </header>


                <div class="grid">
                  <ul class="list-group" id="list-group-accordion">
                      <%
                          if(scopeDescription!=null && !scopeDescription.isEmpty()) {
                              for (Map.Entry<String,String> scope : scopeDescription.entrySet()) {
                                  String scopeName=scope.getKey();
                                  String description=scope.getValue();
                      %>
                               <li class="list-group-item">
                                   <p class="list-group-heading" data-toggle="collapse" data-target="#<%=scopeName%>" data-parent="#list-group-accordion">
                                       <img src="mcx-user-registration/mcresources/img/privacy-list.jpg" alt="Application logo">
                                       Accessing <%=scopeName%> API<i class="fa fa-chevron-right pull-right"></i>
                                   </p>
                                   <div  class="collapse" id="<%=scopeName%>"><%=description%>"</div>
                               </li>

                      <%       }
                         } %>
                  </ul>
                </div>

                <form  action="user_consent_response_bc.do" method="GET" class="form-horizontal" id="userconsent"  data-parsley-validate>
                    <input type="hidden" name="id" value="<%=id%>"/>
                    <input type="hidden" name="newUser" value="<%=isRegistering%>"/>

                    <div class="grid">
                        <div class="grid__item one-half">
                               <button id="approve-btn" type="submit" class="btn btn--full btn--topmargin" name="action" value="approve"s>Approve</button>
                        </div>

                        <div class="grid__item one-half">
                            <button id="deny-btn" type="submit" class="btn btn-danger btn--full btn--topmargin" name="action" value="deny">Deny</button>
                        </div>

                        <%
                            if(approve_all_enable) {
                        %>
                        <div class="grid__item one-whole">
                            <button id="approveall-btn" type="submit" class="btn btn-normal btn--full btn--topmargin" name="action" value="approveall">Approve Always</button>
                        </div>
                        <%  } %>

                    </div>
                </form>
            </main>
        <% } %> <!-- endif: isSessionExpired-->
    </div>
    <script type="text/javascript">


        $(function() {
          $('.collapse').on('show.bs.collapse', function() {
            var toggle = $('[data-target="#' + this.id + '"]');
            if (toggle) {
              var parent = toggle.attr('data-parent');
              if (parent) {
                $(parent).find('.collapse.in').collapse('hide');
              }
            }
          });
        })
    </script>

</body>

</html>
