<%--
  ~ Copyright (c) 2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="javax.servlet.jsp.jstl.core.Config" %>


    <%
        String stat = request.getParameter("status");
        String statusMessage = request.getParameter("statusMsg");
        if (stat == null || statusMessage == null) {
            ResourceBundle properties = ResourceBundle.getBundle(
                    getServletContext().getInitParameter("javax.servlet.jsp.jstl.fmt.localizationContext"),
                    Locale.forLanguageTag(Config.get(getServletContext(), Config.FMT_LOCALE).toString()));
            stat = properties.getString("common-error-message");
            statusMessage = properties.getString("common-error-description");
        }
        session.invalidate();
    %>

    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WSO2 Identity Server</title>

        <link rel="icon" href="images/favicon.png" type="image/x-icon"/>
        <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/Roboto.css" rel="stylesheet">
        <link href="css/custom-common.css" rel="stylesheet">


        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <![endif]-->
    </head>

    <body>

    <!-- header -->
    <header class="header header-default">
        <div class="container-fluid"><br></div>
        <div class="container-fluid">
            <div class="pull-left brand float-remove-xs text-center-xs">
                <a href="#">
                    <img src="images/logo-inverse.svg" alt="wso2" title="wso2" class="logo">

                    <h1><em>Identity Server</em></h1>
                </a>
            </div>
        </div>
    </header>

    <!-- page content -->
        <div class="row" id="accLock" style="display:none">
            <div class="col-md-12">
                <!-- content -->
                <div class="container col-xs-7 col-sm-5 col-md-4 col-lg-3 col-centered wr-content wr-login col-centered">
                    <div>
                        <h2 class="wr-title uppercase blue-bg padding-double white boarder-bottom-blue margin-none">Login Failed</h2>
                    </div>

                    <div class="boarder-all col-lg-12 padding-top-double padding-bottom-double error-alert  ">
                        <div class="font-medium"><strong>Attention:</strong> </div>
                        <div class="padding-bottom-double">
                            Your account has been locked.Try again in <label class="basicAuth-label" id="remainingTime"></label>
                        </div>
                    </div>
                </div>
                <!-- /content -->

            </div>
        </div>


     <!-- page content -->
        <div class="row" id="accUnlock" style="display:none">
            <div class="col-md-12">
                <!-- content -->
                <div class="container col-xs-7 col-sm-5 col-md-4 col-lg-3 col-centered wr-content wr-login col-centered">
                    <div>
                        <h2 class="wr-title uppercase blue-bg padding-double white boarder-bottom-blue margin-none"><%=Encode.forHtmlContent(stat)%> </h2>
                    </div>

                    <div class="boarder-all col-lg-12 padding-top-double padding-bottom-double error-alert  ">
                        <div class="font-medium"><strong>Attention:</strong> </div>
                        <div class="padding-bottom-double">
                            <%=Encode.forHtmlContent(statusMessage)%>
                        </div>
                    </div>
                </div>
                <!-- /content -->

            </div>
        </div>

    <!-- footer -->
    <footer class="footer">
        <div class="container-fluid">
            <p>WSO2 Identity Server | &copy;
                <script>document.write(new Date().getFullYear());</script>
                <a href="http://wso2.com/" target="_blank"><i class="icon fw fw-wso2"></i> Inc</a>. All Rights Reserved.
            </p>
        </div>
    </footer>

    <script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
    <script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>

    <script>
        $.urlParam = function(name){
    	var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    	return results[1] || 0;
        }

        if( $.urlParam('errorCode') == '17003'){

            var userName = $.urlParam('failedUsername');
            var xhttp = new XMLHttpRequest();
            var apiUrl = window.location.protocol+'//'+window.location.hostname+(location.port ? ':'+location.port: '')+"/authproxy/accountLockRemainingTime/"+userName;
            xhttp.onreadystatechange = function() {
                if (this.status == 200) {

                    if(parseInt(this.responseText) <= 0){

                        document.getElementById("remainingTime").innerHTML =
                                            "1 minute.";

                        var relayState = $.urlParam('RelayState');
                        var ssoAuthSessionId = $.urlParam('SSOAuthSessionID');
                        var commonAuthCallerPath = $.urlParam('commonAuthCallerPath');
                        var forceAuth = $.urlParam('forceAuth');
                        var passiveAuth = $.urlParam('passiveAuth');
                        var tenantDomain = $.urlParam('tenantDomain');
                        var sessionDataKey = $.urlParam('sessionDataKey');
                        var relyingParty = $.urlParam('relyingParty');
                        var type = $.urlParam('type');
                        var sp = $.urlParam('sp');
                        var isSaaSApp = $.urlParam('isSaaSApp');
                        var loginUrl = window.location.protocol+'//'+window.location.hostname+(location.port ? ':'+location.port: '')+"/authenticationendpoint/login.do?RelayState="+relayState+"&SSOAuthSessionID="+ssoAuthSessionId+"&commonAuthCallerPath="+commonAuthCallerPath+"&forceAuth="+forceAuth+"&passiveAuth="+passiveAuth+"&tenantDomain="+tenantDomain+"&sessionDataKey="+sessionDataKey+"&relyingParty="+relyingParty+"&type="+type+"&sp="+sp+"&isSaaSApp="+isSaaSApp+"&authenticators=BasicAuthenticator:LOCAL";

                        window.location.replace(loginUrl);
                    }else if(parseInt(this.responseText) == 1){
                        document.getElementById("remainingTime").innerHTML =
                        this.responseText+" minute.";
                     } else{
                         document.getElementById("remainingTime").innerHTML =
                                                 this.responseText+" minutes.";
                     }
                    }
            };
            xhttp.open("GET", apiUrl, true);
            xhttp.send();

        document.getElementById("accLock").style = "";
        }else{
        document.getElementById("accUnlock").style= "";
        }

        $('#popover').popover({
            html: true,
            title: function () {
                return $("#popover-head").html();
            },
            content: function () {
                return $("#popover-content").html();
            }
        });

    </script>

    <script type="text/javascript" src="js/u2f-api.js"></script>
    
    </body>
    </html>
