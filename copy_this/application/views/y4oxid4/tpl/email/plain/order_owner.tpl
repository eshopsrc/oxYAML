[{*
#########################################################################
#	$Id: b80071fdd5eced1aabe037630b5824abfdfd6b91 $
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
[{ assign var="currency"  value=$oEmailView->getCurrency() }]
[{ assign var="user"      value=$oEmailView->getUser() }]
[{ assign var="basket"    value=$order->getBasket() }]
[{ assign var="oDelSet"   value=$order->getDelSet() }]
[{ assign var="payment"   value=$order->getPayment() }]

[{if $payment->oxuserpayments__oxpaymentsid->value == "oxempty"}]
[{oxcontent ident="oxadminordernpplainemail"}]
[{else}]
[{oxcontent ident="oxadminorderplainemail"}]
[{/if}]

[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_ORDERNOMBER" }] [{ $order->oxorder__oxordernr->value }]

[{if $oViewConf->getShowVouchers() }]
[{ foreach from=$order->getVoucherList() item=voucher}]
[{ assign var="voucherseries" value=$voucher->getSerie() }]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_USEDCOUPONS" }] [{$voucher->oxvouchers__oxvouchernr->value}] - [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_DICOUNT" }] [{$voucherseries->oxvoucherseries__oxdiscount->value}] [{ if $voucherseries->oxvoucherseries__oxdiscounttype->value == "absolute"}][{ $currency->sign}][{else}]%[{/if}]
[{/foreach }]
[{/if}]

[{assign var="basketitemlist" value=$basket->getBasketArticles() }]
[{foreach key=basketindex from=$basket->getContents() item=basketitem}]
[{assign var="basketproduct" value=$basketitemlist.$basketindex }]
[{ $basketproduct->oxarticles__oxtitle->getRawValue()|strip_tags }][{ if $basketproduct->oxarticles__oxvarselect->value}], [{ $basketproduct->oxarticles__oxvarselect->value}][{/if}]
[{ if $basketitem->getChosenSelList() }][{foreach from=$basketitem->getChosenSelList() item=oList}][{ $oList->name }] [{ $oList->value }][{/foreach}][{/if}]
[{ if $basketitem->getPersParams() }][{foreach key=sVar from=$basketitem->getPersParams() item=aParam}][{$sVar}] : [{$aParam}][{/foreach}][{/if}]
[{if $oViewConf->getShowGiftWrapping() }]
[{assign var="oWrapping" value=$basketitem->getWrapping() }]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPING" }] [{ if !$basketitem->getWrappingId() }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_NONE" }][{else}][{$oWrapping->oxwrapping__oxname->getRawValue()}][{/if}]
[{/if}]
[{ if $basketproduct->oxarticles__oxorderinfo->value }][{ $basketproduct->oxarticles__oxorderinfo->getRawValue() }][{/if}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_UNITPRICE" }] [{ $basketitem->getFUnitPrice() }] [{ $currency->name}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_QUANTITY" }] [{$basketitem->getAmount()}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_VAT" }] [{$basketitem->getVatPercent() }]%
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTAL" }] [{ $basketitem->getFTotalPrice() }] [{ $currency->name}]
[{/foreach}]
------------------------------------------------------------------
[{ if !$basket->getDiscounts()}]
[{* netto price *}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALNET" }] [{ $basket->getProductsNetPrice() }] [{ $currency->name}]
[{* VATs *}]
[{foreach from=$basket->getProductVats() item=VATitem key=key}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX1" }] [{ $key }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX2" }] [{ $VATitem }] [{ $currency->name}]
[{/foreach}]
[{/if}]
[{* brutto price *}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALGROSS" }] [{ $basket->getFProductsPrice() }] [{ $currency->name}]
[{* applied discounts *}]
[{ if $basket->getDiscounts()}]
  [{foreach from=$basket->getDiscounts() item=oDiscount}]
  [{if $oDiscount->dDiscount < 0 }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_CHARGE" }][{else}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_DICOUNT" }][{/if}] [{ $oDiscount->sDiscount }]: [{if $oDiscount->dDiscount < 0 }][{ $oDiscount->fDiscount|replace:"-":"" }][{else}]-[{ $oDiscount->fDiscount }][{/if}] [{ $currency->name}]
  [{/foreach}]
  [{* netto price *}]
  [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TOTALNET" }] [{ $basket->getProductsNetPrice() }] [{ $currency->name}]
  [{* VATs *}]
  [{foreach from=$basket->getProductVats() item=VATitem key=key}]
    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX1" }] [{ $key }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX2" }] [{ $VATitem }] [{ $currency->name}]
  [{/foreach}]
[{/if}]
[{* voucher discounts *}]
[{if $oViewConf->getShowVouchers() && $basket->getVoucherDiscValue() }]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_COUPON" }] [{ if $basket->getFVoucherDiscountValue() > 0 }]-[{/if}][{ $basket->getFVoucherDiscountValue()|replace:"-":"" }] [{ $currency->name}]
[{/if}]
[{* delivery costs *}]
[{* delivery VAT (if available) *}]
[{if $basket->getDelCostVat() > 0}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGNET" }] [{ $basket->getDelCostNet() }] [{ $currency->name}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TAX1" }] [{ $basket->getDelCostVatPercent() }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TAX2" }]  [{ $basket->getDelCostVat() }] [{ $currency->name}]
[{/if}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGGROSS1" }] [{if $basket->getDelCostVat() > 0}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGGROSS2" }] [{/if}]: [{ $basket->getFDeliveryCosts() }] [{ $currency->name}]
[{* payment sum *}]
[{ if $basket->getPaymentCosts() }]
[{if $basket->getPaymentCosts() >= 0}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT1" }][{else}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT2" }][{/if}] [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEDISCOUNT3" }] [{ $basket->getPayCostNet() }] [{ $currency->name}]
[{* payment sum VAT (if available) *}]
  [{ if $basket->getDelCostVat() }]
  [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEVAT1" }] [{ $basket->getPayCostVatPercent()}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTCHARGEVAT2" }] [{ $basket->getPayCostVat() }] [{ $currency->name}]
  [{/if}]
[{/if}]
[{ if $basket->getTsProtectionCosts() }]
  [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTIONCHARGETAX1" }] [{ $basket->getTsProtectionVatPercent()}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTIONCHARGETAX2" }] [{ $basket->getTsProtectionVat() }] [{ $currency->name}]
  [{ if $basket->getTsProtectionVat() }]
  [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_TSPROTECTION" }] [{ $basket->getTsProtectionNet() }] [{ $currency->sign}]
  [{/if}]
[{/if}]

[{ if $oViewConf->getShowGiftWrapping() && $basket->getFWrappingCosts() }]
  [{if $basket->getWrappCostVat()}]
    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGNET" }] [{ $basket->getWrappCostNet() }] [{ $currency->name}]
    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX21" }] [{ $basket->getWrappCostVatPercent() }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PLUSTAX22" }] [{ $basket->getWrappCostVat() }] [{ $currency->name}]
  [{/if}]
    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGANDGREETINGCARD1" }][{if $basket->getWrappCostVat()}] [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_WRAPPINGANDGREETINGCARD2" }][{/if}]: [{ $basket->getFWrappingCosts() }] [{ $currency->name}]
[{/if}]

[{* grand total price *}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_GRANDTOTAL" }] [{ $basket->getFPrice() }] [{ $currency->name}]
[{if $basket->oCard }]
    [{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_ATENTIONGREETINGCARD" }]
    [{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_YOURMESSAGE" }]
    [{$basket->getCardMessage()}]
[{/if}]

[{ if $order->oxorder__oxremark->value }]
[{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_MESSAGE" }] [{ $order->oxorder__oxremark->getRawValue() }]
[{/if}]

[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_PAYMENTINFO" }]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PAYMENTMETHOD" }][{ $payment->oxpayments__oxdesc->getRawValue() }] [{ if $basket->getPaymentCosts() }]([{ $basket->getFPaymentCosts() }] [{ $currency->sign}])[{/if}]
[{ oxmultilang ident="EMAIL_ORDER_OWNER_HTML_PAYMENTINFOOFF" }]
[{*
[{foreach from=$payment->aDynValues item=value }]
[{assign var="ident" value='EMAIL_ORDER_OWNER_HTML_'|cat:$value->name}]
[{assign var="ident" value=$ident|oxupper }]
[{oxmultilang ident=$ident }] : [{ $value->value }]
[{/foreach }]
*}]
[{/if}]

[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_EMAILADDRESS" }] [{ $user->oxuser__oxusername->value }]

[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_BILLINGADDRESS" }]
[{ $order->oxorder__oxbillcompany->getRawValue() }]
[{ $order->oxorder__oxbillsal->value|oxmultilangsal }] [{ $order->oxorder__oxbillfname->getRawValue() }] [{ $order->oxorder__oxbilllname->getRawValue() }]
[{if $order->oxorder__oxbilladdinfo->value }][{ $order->oxorder__oxbilladdinfo->getRawValue() }][{/if}]
[{ $order->oxorder__oxbillstreet->getRawValue() }] [{ $order->oxorder__oxbillstreetnr->value }]
[{ $order->oxorder__oxbillstateid->value }]
[{ $order->oxorder__oxbillzip->value }] [{ $order->oxorder__oxbillcity->getRawValue() }]
[{ $order->oxorder__oxbillcountry->getRawValue() }]
[{if $order->oxorder__oxbillustid->value}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_VATIDNOMBER" }] [{ $order->oxorder__oxbillustid->value }][{/if}]
[{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_PHONE" }] [{ $order->oxorder__oxbillfon->value }]

[{ if $order->oxorder__oxdellname->value }][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGADDRESS" }]
[{ $order->oxorder__oxdelcompany->getRawValue() }]
[{ $order->oxorder__oxdelsal->value|oxmultilangsal }] [{ $order->oxorder__oxdelfname->getRawValue() }] [{ $order->oxorder__oxdellname->getRawValue() }]
[{if $order->oxorder__oxdeladdinfo->value }][{ $order->oxorder__oxdeladdinfo->getRawValue() }][{/if}]
[{ $order->oxorder__oxdelstreet->getRawValue() }] [{ $order->oxorder__oxdelstreetnr->value }]
[{ $order->oxorder__oxdelstateid->value }]
[{ $order->oxorder__oxdelzip->value }] [{ $order->oxorder__oxdelcity->getRawValue() }]
[{ $order->oxorder__oxdelcountry->getRawValue() }]
[{/if}]

[{if $payment->oxuserpayments__oxpaymentsid->value != "oxempty"}][{ oxmultilang ident="EMAIL_ORDER_CUST_HTML_SHIPPINGCARRIER" }] [{ $order->oDelSet->oxdeliveryset__oxtitle->getRawValue() }]
[{/if}]

[{ oxcontent ident="oxemailfooterplain" }]
