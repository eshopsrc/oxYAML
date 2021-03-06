[{*
#########################################################################
#	$Id: e1576afed62951f5290ad1c0d1ec05a8c4345096 $
#	Project:	YAML4 OXID eSales 4 Template 4.8.x
#	ProjectId:	oxYaml 
#	Copyright: 	Rene Ettling (r.ettling@eshop-source.com)
#				(http://www.eshop-source.com)
#				Some parts based on YAML4, Copyright 2005-2012, Dirk Jesse
#
#	Lizenz:		CC BY 3.0
#	Deutsch:	http://creativecommons.org/licenses/by/3.0/de/
#	Schweiz:	http://creativecommons.org/licenses/by/3.0/ch/
#	Englisch:	http://creativecommons.org/licenses/by/3.0/de/deed.en
#
#########################################################################
*}]

[{ assign var="shop"      value=$oEmailView->getShop() }]
[{ assign var="oViewConf" value=$oEmailView->getViewConfig() }]

[{ oxcontent ident="oxordersendplainemail" }]

[{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_ORDERSHIPPEDTO" }]

[{ if $order->oxorder__oxdellname->value }]
    [{ $order->oxorder__oxdelcompany->getRawValue() }]
    [{ $order->oxorder__oxdelfname->getRawValue() }] [{ $order->oxorder__oxdellname->getRawValue() }]
    [{ $order->oxorder__oxdelstreet->getRawValue() }] [{ $order->oxorder__oxdelstreetnr->value }]
    [{ $order->oxorder__oxdelstateid->value }]
    [{ $order->oxorder__oxdelzip->value }] [{ $order->oxorder__oxdelcity->getRawValue() }]
[{else}]
    [{ $order->oxorder__oxbillcompany->getRawValue() }]
    [{ $order->oxorder__oxbillfname->getRawValue() }] [{ $order->oxorder__oxbilllname->getRawValue() }]
    [{ $order->oxorder__oxbillstreet->getRawValue() }] [{ $order->oxorder__oxbillstreetnr->value }]
    [{ $order->oxorder__oxbillstateid->value }]
    [{ $order->oxorder__oxbillzip->value }] [{ $order->oxorder__oxbillcity->getRawValue() }]
[{/if}]

[{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_ORDERNOMBER" }] [{ $order->oxorder__oxordernr->value }]

[{foreach from=$order->getOrderArticles(true) item=oOrderArticle}]
[{ $oOrderArticle->oxorderarticles__oxamount->value }] [{ $oOrderArticle->oxorderarticles__oxtitle->getRawValue() }] [{ $oOrderArticle->oxorderarticles__oxselvariant->getRawValue() }]
[{/foreach}]

[{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_YUORTEAM1" }] [{ $shop->oxshops__oxname->getRawValue() }] [{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_YUORTEAM2" }]

[{if $order->getShipmentTrackingUrl()}][{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_SHIPMENTTRACKING" }] [{ $order->getShipmentTrackingUrl()}][{/if}]

[{if $oViewConf->showTs("ORDERCONFEMAIL") && $oViewConf->getTsId() }]
[{ oxmultilang ident="EMAIL_SENDEDNOW_HTML_TS_RATINGS_RATEUS" }]
[{ $oViewConf->getTsRatingUrl() }]
[{/if}]

[{ oxcontent ident="oxemailfooterplain" }]