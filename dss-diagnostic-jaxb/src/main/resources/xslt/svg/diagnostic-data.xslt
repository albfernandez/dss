<?xml version="1.0"?>

<xsl:stylesheet version="2.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
    	xmlns:diag="http://dss.esig.europa.eu/validation/diagnostic"
		xmlns="http://www.w3.org/2000/svg">
		
 <xsl:output
   method="xml"
   indent="yes"
   standalone="no"
   doctype-public="-//W3C//DTD SVG 1.1//EN"
   doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
   media-type="image/svg" />
 
	<xsl:template match="/diag:DiagnosticData">
	  <svg xmlns="http://www.w3.org/2000/svg">
		<style>
			.trusted {
				stroke: #28a745;
				fill: #28a745;
			}
			.not-trusted {
				stroke: black;
				fill: black;
			}
		    
			.revoked {
				stroke: #dc3545;
			}
			.not-revoked {
				stroke: #28a745;
			}
			.svg-certificate-revocation { 
				overflow: visible;
			}
			
		</style>
		<script type="text/javascript">
    		<![CDATA[
    		
    			document.getSignatureIds = function() {
    				var ids = new Array();
    				var signatures = getSignatures();
    				for (var elementIdx = 0; elementIdx < signatures.length; elementIdx++) {
						var signature = signatures[elementIdx];
						ids.push(signature.id);
					}
    				return ids;	
    			}
    			
    			document.getCertificateIds = function() {
    				var ids = new Array();
    				
    				var certificates = getCertificates();
    				for (var elementIdx = 0; elementIdx < certificates.length; elementIdx++) {
						var certificate = certificates[elementIdx];
						ids.push(certificate.id);
					}
    				return ids;	
    			}
    			
    			document.initSVG = function(width, height, padding) {
    				return new Representation(width, height, padding, getTimeline(), getValidationTime(), getCertificates(), getRevocations(), getCertificateRevocations(), getSignatures(), getTimestamps());
    			}
    			
    			class Representation {
    			
    				constructor(width, height, padding, timeline, validationTime, certificates, revocations, certificateRevocations, signatures, timestamps) {
    					this.width = width;
    					this.height = height;
    					this.padding = padding;
    					this.timeline = timeline;
    					this.validationTime = validationTime;
	    				this.certificates =	certificates;
	    				this.revocations = revocations;
	    				this.certificateRevocations = certificateRevocations;
	    				this.signatures = signatures;
	    				this.timestamps = timestamps;
	    			
	    				this.minDate = null;
	    				this.maxDate = null;
	    				this.ratio = null;
    				}
    				
    				displayFirstSignature() {
    					if (this.signatures !=null) {
    						var currentSignature = this.signatures[0];
    						this.displaySignature(currentSignature);
    					}
    				}
    				
    				displaySignatureById(signatureId) {
   						var currentElement  = this.getSignatureById(signatureId);
						this.displaySignature(currentElement);
    				}
    				
    				displaySignature(signature) {
						this.hideAll();
						
						this.computeRatio(this.collectDatesFromSignature(signature));
						this.drawSig(signature);						
    				}
    				
    				displayCertificateChainById(certId) {
   						var currentCert  = this.getCertificateById(certId);
						this.displayCertificateChain(currentCert);
    				}
    				
    				displayCertificateChain(currentCert) {
						this.hideAll();
						var chain = this.getCompleteCertificateChain(currentCert);
						this.computeRatio(this.collectDatesFromChain(chain));
						this.drawChain(chain);						
    				}
    				
    				getCompleteCertificateChain(cert) {
    					var chain = new Array();
    					
						var currentCert = cert;
    					do {
							chain.push(currentCert);
							currentCert = this.getIssuer(currentCert);
						} while (currentCert != null) ;
    					
    					return chain;
    				}
    				
    				getIssuer(currentCert) {
    					if (currentCert.signingCertificate !=null) {
    						return this.getCertificateById(currentCert.signingCertificate);
    					}
    					return null;
    				}
    				
    				computeRatio(dates) {
    					this.minDate = getMinDate(dates);
						this.maxDate = getMaxDate(dates);
						var range = this.maxDate.getTime() - this.minDate.getTime();
						this.ratio = (this.width - this.padding) / range;
					}
					
					drawSig(signature) {
						this.drawValidationTime();
						this.drawTimeline();
						
						var y = this.height - 70;
					
						signature.posX(this.getPosX(signature.claimedSigningTime));
						signature.posY(y);
						signature.show();
						
						var cert = this.getCertificateById(signature.signingCertificate);
						this.drawCert(cert, y);
						
	    				for (var elementIdx = 0; elementIdx < signature.timestamps.length; elementIdx++) {
							var timestampId = signature.timestamps[elementIdx];
							var timestamp = this.getTimestampById(timestampId);
							
							y = y -15;
							this.drawTimestamp(timestamp, y);
						}
					}
					
					drawTimestamp(timestamp, y) {
						if (timestamp !=null) {
							timestamp.posX(this.getPosX(timestamp.productionTime));
							timestamp.posY(y);
							timestamp.show();
							
							var cert = this.getCertificateById(timestamp.signingCertificate);
							this.drawCert(cert, y);
						}
					}
					
					drawChain(chain) {
						this.drawValidationTime();
						this.drawTimeline();
					
						var y = this.height - 70;
					
	    				for (var elementIdx = 0; elementIdx < chain.length; elementIdx++) {
							var cert = chain[elementIdx];
							this.drawCert(cert, y);
						
							y = y -15;
						}
					}
					
					drawValidationTime() {
						this.validationTime.posX(this.getPosX(this.validationTime.time));
						this.validationTime.posY(this.height - 30);
						this.validationTime.show();
					}
					
					drawTimeline() {
						this.timeline.posY(this.height - 50);
						this.timeline.show();
					}
										
					drawCert(cert, y) {
						if (cert != null) {
							cert.posX(this.getPosX(cert.notBefore));
							cert.width(this.getWidth(cert.notBefore, cert.notAfter));
							cert.posY(y);
							cert.show();
							
							var revocs = this.getRevocationsForCertificate(cert.id);
	    					for (var elementIdx = 0; elementIdx < revocs.length; elementIdx++) {
								var certRevoc = revocs[elementIdx];
								this.drawCertRevocation(certRevoc, y);
							}
						}
					}
					
					drawCertRevocation(certRevoc, y) {
						if (certRevoc !=null) {
						
							if (certRevoc.productionTime !=null) {
								certRevoc.posX(this.getPosX(certRevoc.productionTime));
							} else {
								certRevoc.posX(this.getPosX(certRevoc.revocationDate));
							}
						
							certRevoc.posY(y);
							certRevoc.show();
 						}
					}
					
					getPosX(date) {
						return ((date.getTime() - this.minDate.getTime()) * this.ratio) + (this.padding / 2);
					}
					
					getWidth(min, max) {
						return (max.getTime() - min.getTime()) * this.ratio;
					}
    				
    				collectDatesFromSignature(signature) {
    					var dates = new Array();
						dates.push(this.validationTime.time);
						dates.push(signature.claimedSigningTime);
						
						var cert = this.getCertificateById(signature.signingCertificate);
						dates = dates.concat(this.collectDatesForCert(cert));

	    				for (var elementIdx = 0; elementIdx < signature.timestamps.length; elementIdx++) {
							var timestampId = signature.timestamps[elementIdx];
							var timestamp = this.getTimestampById(timestampId);
							dates = dates.concat(this.collectDatesForTimestamp(timestamp));
						}
						
						return dates;
					}
					
					collectDatesFromChain(chain) {
    					var dates = new Array();
						dates.push(this.validationTime.time);
					
	    				for (var elementIdx = 0; elementIdx < chain.length; elementIdx++) {
							var cert = chain[elementIdx];
							dates = dates.concat(this.collectDatesForCert(cert));
						}
						return dates;
					}
					
					collectDatesForCert(cert) {
    					var dates = new Array();
						if (cert !=null) {
	 						dates.push(cert.notBefore);
							dates.push(cert.notAfter);
							
							var revocs = this.getRevocationsForCertificate(cert.id);
	    					for (var elementIdx = 0; elementIdx < revocs.length; elementIdx++) {
								var certRevoc = revocs[elementIdx];
							
								if (certRevoc.productionTime !=null) {
									dates.push(certRevoc.productionTime);
								}	
								if (certRevoc.revocationDate !=null) {
									dates.push(certRevoc.revocationDate);
								}	
							}
						}
						return dates;
					}
					
					collectDatesForTimestamp(timestamp) {
    					var dates = new Array();
    					if (timestamp != null) {
	 						dates.push(timestamp.productionTime);
		 						
							var cert = this.getCertificateById(timestamp.signingCertificate);
							dates = dates.concat(this.collectDatesForCert(cert));
						}
						return dates;
					}
    				
    				getCertificateById(certId) {
    					for (var elementIdx = 0; elementIdx < this.certificates.length; elementIdx++) {
							var currentElement = this.certificates[elementIdx];
							if (certId == currentElement.id) {
								return currentElement;
   							}
   						}
    				}
    				
    				getSignatureById(sigId) {
    					for (var elementIdx = 0; elementIdx < this.signatures.length; elementIdx++) {
							var currentElement = this.signatures[elementIdx];
							if (sigId == currentElement.id) {
								return currentElement;
   							}
   						}
    				}
    				
    				getTimestampById(tstId) {
    					for (var elementIdx = 0; elementIdx < this.timestamps.length; elementIdx++) {
							var currentElement = this.timestamps[elementIdx];
							if (tstId == currentElement.id) {
								return currentElement;
   							}
   						}
    				}
    				
    				getRevocationsForCertificate(certId) {
    					var result = new Array();
    					for (var elementIdx = 0; elementIdx < this.certificateRevocations.length; elementIdx++) {
							var currentElement = this.certificateRevocations[elementIdx];
							if (certId == currentElement.certId) {
								result.push(currentElement);
   							}
   						}
   						return result;
    				}
    				
    				hideAll() {
<!-- 						console.log("hideAll"); -->
    					this.validationTime.hide();
    					hideGraphicItems(this.certificates);
    					hideGraphicItems(this.revocations);
    					hideGraphicItems(this.certificateRevocations);
    					hideGraphicItems(this.signatures);
    					hideGraphicItems(this.timestamps);
<!--     					console.log("hideAll : done"); -->
    				}
    				
    			}    	
    			
    			class GraphicItem  {
    				constructor(svgElement) {
    					this.svgElement = svgElement;
    					this.id = svgElement.getAttribute("id");
					}
					
					posX(newX) {
						this.svgElement.setAttribute("x", Math.round(newX));
					}
					posY(newY) {
						this.svgElement.setAttribute("y", Math.round(newY));
					}
					width(newWidth) {
						this.svgElement.setAttribute("width", Math.round(newWidth));
					}
					hide() {
						this.svgElement.style.display="none";
					}
					show() {
						this.svgElement.style.display="";
					}
					
    			}
    			
    			class ValidationTime extends GraphicItem {
    			 	constructor(svgElement, time) {
    			 		super(svgElement);
    			 		this._time = time;
    			 	}
    			 	
    			 	get time() {
        				return this._time;
    				}
    			 }
    			 
    			 class Timeline extends GraphicItem {
    			 	constructor(svgElement) {
    			 		super(svgElement);
    			 	}
    			 }
    			
    			class Signature extends GraphicItem {
    			 	constructor(svgElement, claimedSigningTime, signingCertificate, timestamps) {
    			 		super(svgElement);
    			 		this.claimedSigningTime = claimedSigningTime;
    			 		this.signingCertificate = signingCertificate;
    			 		this.timestamps = timestamps;
    			 	}
    			 }
    			 
    			 class Timestamp extends GraphicItem {
    			 	constructor(svgElement, productionTime, signingCertificate) {
    			 		super(svgElement);
    			 		this.productionTime = productionTime;
    			 		this.signingCertificate = signingCertificate;
    			 	}
    			 }
    			
    			 class Certificate extends GraphicItem {
    			 	constructor(svgElement, notBefore, notAfter, signingCertificate) {
    			 		super(svgElement);
    			 		this.notBefore = notBefore;
    			 		this.notAfter = notAfter;
    			 		this.signingCertificate = signingCertificate;
    			 	}
    			 }
    			 
    			 class RevocationData extends GraphicItem {
    			 	constructor(svgElement, productionTime, thisUpdate, nextUpdate, expiredCertsOnCrl, archiveCutOff, signingCertificate) {
    			 		super(svgElement);
    			 		this.productionTime = productionTime;
    			 		this.thisUpdate = thisUpdate;
    			 		this.nextUpdate = nextUpdate;
    			 		this.expiredCertsOnCrl = expiredCertsOnCrl;
    			 		this.archiveCutOff = archiveCutOff;
    			 		this.signingCertificate = signingCertificate;
    			 	}
    			 }
    			 
    			 class CertificateRevocation extends GraphicItem {
    			 	constructor(svgElement, certId, revocationId, productionTime, revocationDate, reason) {
    			 		super(svgElement);
    			 		this.certId = certId;
    			 		this.revocationId = revocationId;
    			 		this.productionTime = productionTime;
    			 		this.revocationDate = revocationDate;
    			 		this.reason = reason;
    			 	}
    			 }
    			 
    			  function getTimeline() {
					var element = document.getElementById("svg-global-timeline");
					if (element != null) {
						return new Timeline(element);
					}
					return null;
    			 }
    			 
    			 function getValidationTime() {
					var element = document.getElementById("svg-validation-time");
					if (element != null) {
						var titleElements = element.getElementsByTagName("title");
						if (titleElements.length == 1) {
							return new ValidationTime(element, new Date(titleElements[0].textContent));
						}
					}
					return null;
    			 }
    			 
    			 function getCertificates() {
					var certificates = new Array();
					var elements = document.getElementsByClassName("svg-certificate");
					for (var elementIdx = 0; elementIdx < elements.length; elementIdx++) {
						var currentElement = elements[elementIdx];
						var notBefore =  getUniqueDate(currentElement, "svg-not-before");
						var notAfter =  getUniqueDate(currentElement, "svg-not-after");
						var signingCertificateId = getUniqueValue(currentElement, "svg-signing-cert");
						var cert = new Certificate(currentElement, notBefore, notAfter, signingCertificateId);
						certificates.push(cert);
					}
					return certificates;
    			}
    			
    			function getRevocations() {
					var revocations = new Array();
					var elements = document.getElementsByClassName("svg-revocation");
					for (var elementIdx = 0; elementIdx < elements.length; elementIdx++) {
						var currentElement = elements[elementIdx];
						var productionTime =  getUniqueDate(currentElement, "svg-production-date");
						var thisUpdate =  getUniqueDate(currentElement, "svg-this-update ");
						var nextUpdate =  getUniqueDate(currentElement, "svg-next-update");
						var expiredCertsOnCrl =  getUniqueDate(currentElement, "svg-expired-certs-on-crl");
						var archiveCutOff =  getUniqueDate(currentElement, "svg-archive-cut-off");
						var signingCertificateId = getUniqueValue(currentElement, "svg-signing-cert");
						
						var revocationData = new RevocationData(currentElement, productionTime, thisUpdate, nextUpdate, expiredCertsOnCrl, archiveCutOff, signingCertificateId);
						revocations.push(revocationData);
					}
					return revocations;
    			}
    			
    			function getCertificateRevocations() {
					var certificateRevocations = new Array();
					var elements = document.getElementsByClassName("svg-certificate-revocation");
					for (var elementIdx = 0; elementIdx < elements.length; elementIdx++) {
						var currentElement = elements[elementIdx];
						
						var certId = getUniqueValue(currentElement, "certificate-id");
						var productionTime = getUniqueDate(currentElement, "production-date");
						var revocationTime = getUniqueDate(currentElement, "revocation-date");
						var reason = getUniqueValue(currentElement, "reason");
						
						var certRevoc = new CertificateRevocation(currentElement, certId, null, productionTime, revocationTime, reason);
						certificateRevocations.push(certRevoc);
					}
					return certificateRevocations;
    			}
    			
    			function getSignatures() {
					var signatures = new Array();
					var elements = document.getElementsByClassName("svg-signature");
					for (var elementIdx = 0; elementIdx < elements.length; elementIdx++) {
						var currentElement = elements[elementIdx];
						var claimedSigningTime = getUniqueDate(currentElement, "svg-claimed-signing-time");
						var signingCertificateId = getUniqueValue(currentElement, "svg-signing-cert");
						var timestampIds = getValues(currentElement, "svg-found-timestamp");
						var sig = new Signature(currentElement, claimedSigningTime, signingCertificateId, timestampIds);
						signatures.push(sig);
					}
					return signatures;
    			}
    			
    			function getTimestamps() {
					var timestamps = new Array();
					var elements = document.getElementsByClassName("svg-timestamp");
					for (var elementIdx = 0; elementIdx < elements.length; elementIdx++) {
						var currentElement = elements[elementIdx];
						var productionTime = getUniqueDate(currentElement, "svg-production-time");
						var signingCertificateId = getUniqueValue(currentElement, "svg-signing-cert");
						var timestamp = new Timestamp(currentElement, productionTime, signingCertificateId);
						timestamps.push(timestamp);
					}
					return timestamps;
    			}
    			
    			function hideGraphicItems(items) {
   					if (items !=null) {
    					for (var elementIdx = 0; elementIdx < items.length; elementIdx++) {
							var currentElement = items[elementIdx];
							currentElement.hide();
						}
   					}
   				}	
    			 
				function getUniqueDate(currentElement, cssClass) {
    				var date;
					var items = currentElement.getElementsByClassName(cssClass);
					if (items.length == 1) {
						date = new Date(items[0].textContent);
					}
					return date;
    			}
    			
    			function getUniqueValue(currentElement, cssClass) {
    				var value;
					var items = currentElement.getElementsByClassName(cssClass);
					if (items.length == 1) {
						value = items[0].textContent;
					}
					return value;
    			}
    			
    			function getValues(currentElement, cssClass) {
    				var result = new Array();
					var items = currentElement.getElementsByClassName(cssClass);
					for (var elementIdx = 0; elementIdx < items.length; elementIdx++) {
						var currentElement = items[elementIdx];
						result.push(currentElement.textContent);
					}
					return result;
    			}
    			
    			function getMinDate(dates) {
					var minimalDate = null;
					for (i = 0; i < dates.length; i++) {
						var currentDate = dates[i];
						if (minimalDate == null || minimalDate > currentDate) {
							minimalDate = currentDate;
						}
					}
					return minimalDate;
				}
					
				function getMaxDate(dates) {
					var maximalDate = null;
					for (i = 0; i < dates.length; i++) {
						var currentDate = dates[i];
						if (maximalDate == null || maximalDate < currentDate) {
							maximalDate = currentDate;
						}
					}
					return maximalDate;
				}
		    		
		    ]]>
		</script>
	  	<defs>
	  	
			<g id="signature-symbol">
				<circle cx="0" cy="6" r="5" fill="#bbb" />   
	  		</g>
			<g id="timestamp-symbol">
				<circle cx="0" cy="6" r="5" fill="#17a2b8" />
	  		</g>
	  		
			<g id="revocation-symbol">
			    <line x1="-6" y1="0" x2="6" y2="12" stroke-width="3" />
			    <line x1="-6" y1="12" x2="6" y2="0" stroke-width="3" />
	  		</g>

    		<g id="range">
  				<rect y="0" width="100%" height="4" fill="white" stroke-width="0" />	
  				<rect y="4" width="100%" height="4" stroke-width="0" />	
  				<rect y="8" width="100%" height="4" fill="white" stroke-width="0" />
			    
			    <line x1="0" y1="0" x2="0" y2="12" stroke-width="6" />
			    <line x1="100%" y1="0" x2="100%" y2="12" stroke-width="6" />
	  		</g>
	  		
	  		<g id="timeline">
			    <line x1="795" y1="0" x2="800" y2="5" stroke="blue" stroke-width="1" />
			    <line x1="795" y1="10" x2="800" y2="5" stroke="blue" stroke-width="1" />
			    <line x1="0" y1="5" x2="800" y2="5" stroke="blue" stroke-width="1" />
	  		</g>
	  		
	  	</defs>
	  
		<text id="svg-validation-time"><title>Validation time : <xsl:value-of select="diag:ValidationDate" /></title>?</text>
	  
		<xsl:apply-templates select="diag:UsedCertificates/diag:Certificate"/>
<!-- 	<xsl:apply-templates select="diag:UsedRevocations/diag:Revocation"/> -->
		<xsl:apply-templates select="diag:UsedTimestamps/diag:Timestamp"/>
		<xsl:apply-templates select="diag:Signatures/diag:Signature"/>
		
		<svg id="svg-global-timeline">
  			<use href="#timeline" />
  		</svg>
  		
	  </svg>
	</xsl:template>
	
	<xsl:template match="diag:Signature">
		
  		<use href="#signature-symbol" class="svg-signature">
	
			<xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>
			
			<title>Claimed signing time : <xsl:value-of select="diag:ClaimedSigningTime" /> (<xsl:value-of select="@Id" />)</title>
			
			<text class="svg-claimed-signing-time date" style="display:none">
				<xsl:value-of select="diag:ClaimedSigningTime" />
			</text>
			
			<xsl:if test="diag:SigningCertificate/@Certificate">
				<text class="svg-signing-cert" style="display:none">
					<xsl:value-of select="diag:SigningCertificate/@Certificate" />
				</text>
			</xsl:if>
			
			<xsl:apply-templates select="diag:FoundTimestamps/diag:FoundTimestamp" />
		</use>
	</xsl:template>
	
	<xsl:template match="diag:FoundTimestamp">
		<text class="svg-found-timestamp" style="display:none">
			<xsl:value-of select="@Timestamp" />
		</text>
	</xsl:template>
	
	<xsl:template match="diag:Timestamp">
		<svg class="svg-timestamp"> 
			<xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>
			
			<title>Production time : <xsl:value-of select="diag:ProductionTime" /> (<xsl:value-of select="@Id" />)</title>
			
			<text class="svg-production-time date" style="display:none">
				<xsl:value-of select="diag:ProductionTime" />
			</text>
			
			<xsl:if test="diag:SigningCertificate/@Certificate">
				<text class="svg-signing-cert" style="display:none">
					<xsl:value-of select="diag:SigningCertificate/@Certificate" />
				</text>
			</xsl:if>
			
  			<use href="#timestamp-symbol"  />
		</svg>
	</xsl:template>
	
	<xsl:template match="diag:Certificate">
		<svg class="svg-certificate">
			<xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>
			
			<title><xsl:value-of select="@Id" /></title>
			
			<text class="svg-not-before date" style="display:none">
				<xsl:value-of select="diag:NotBefore" />
			</text>
			<text class="svg-not-after date" style="display:none">
				<xsl:value-of select="diag:NotAfter" />
			</text>
			
			<xsl:if test="diag:SigningCertificate/@Certificate">
				<text class="svg-signing-cert" style="display:none">
					<xsl:value-of select="diag:SigningCertificate/@Certificate" />
				</text>
			</xsl:if>
			
  			<use href="#range">
  				<xsl:choose>
	  				<xsl:when test="contains(diag:Trusted,'true')">
	  					<xsl:attribute name="class">trusted</xsl:attribute>
	  				</xsl:when>
	  				<xsl:otherwise>
	  					<xsl:attribute name="class">not-trusted</xsl:attribute>
	  				</xsl:otherwise>
  				</xsl:choose>
  			</use>
		</svg>
		
		<xsl:apply-templates select="diag:Revocations/diag:CertificateRevocation"/>
	</xsl:template>
	
	<xsl:template match="diag:CertificateRevocation">
		<xsl:variable name="revocationId"><xsl:value-of select="@Revocation" /></xsl:variable>
		<xsl:variable name="certificateId"><xsl:value-of select="../../@Id" /></xsl:variable>
		
		<svg class="svg-certificate-revocation">
			<title>
				<xsl:choose>
					<xsl:when test="diag:RevocationDate">
						Revoked @ <xsl:value-of select="diag:RevocationDate" /> (<xsl:value-of select="$revocationId" />)
					</xsl:when>
					<xsl:otherwise>
						Production time : <xsl:value-of select="//diag:Revocation[@Id=$revocationId]/diag:ProductionDate" /> (<xsl:value-of select="$revocationId" />)
					</xsl:otherwise>	
				</xsl:choose>
			</title>		

			<text class="certificate-id" style="display:none">
				<xsl:value-of select="$certificateId" />
			</text>

			<xsl:choose>
				<xsl:when test="diag:RevocationDate">
					<text class="revocation-reason" style="display:none">
						<xsl:value-of select="diag:Reason" />
					</text>		
					<text class="revocation-date date" style="display:none">
						<xsl:value-of select="diag:RevocationDate" />
					</text>			
  					<use href="#revocation-symbol" class="revoked" />
				</xsl:when>
				<xsl:otherwise>
					<text class="production-date date" style="display:none">
						<xsl:value-of select="//diag:Revocation[@Id=$revocationId]/diag:ProductionDate" />
					</text>		
  					<use href="#revocation-symbol" class="not-revoked" />
				</xsl:otherwise>
			</xsl:choose>
		</svg>
	</xsl:template>
	
	
<!-- 	<xsl:template match="diag:Revocation"> -->
<!-- 		<rect width="200" height="10" fill="red" class="svg-revocation"> -->
<!-- 			<xsl:attribute name="id"><xsl:value-of select="@Id" /></xsl:attribute>			 -->
<!-- 			<text class="svg-production-date date"> -->
<!-- 				<xsl:value-of select="diag:ProductionDate" /> -->
<!-- 			</text> -->
<!-- 			<text class="svg-this-update date"> -->
<!-- 				<xsl:value-of select="diag:ThisUpdate" /> -->
<!-- 			</text> -->
<!-- 			<xsl:if test="diag:NextUpdate"> -->
<!-- 				<text class="svg-next-update date"> -->
<!-- 					<xsl:value-of select="diag:NextUpdate" /> -->
<!-- 				</text> -->
<!-- 			</xsl:if> -->
<!-- 			<xsl:if test="diag:ExpiredCertsOnCRL"> -->
<!-- 				<text class="svg-expired-certs-on-crl date"> -->
<!-- 					<xsl:value-of select="diag:ExpiredCertsOnCRL" /> -->
<!-- 				</text> -->
<!-- 			</xsl:if> -->
<!-- 			<xsl:if test="diag:ArchiveCutOff"> -->
<!-- 				<text class="svg-archive-cut-off date"> -->
<!-- 					<xsl:value-of select="diag:ArchiveCutOff" /> -->
<!-- 				</text> -->
<!-- 			</xsl:if> -->
<!-- 			<xsl:if test="diag:SigningCertificate/@Certificate"> -->
<!-- 				<text class="svg-signing-cert"> -->
<!-- 					<xsl:value-of select="diag:SigningCertificate/@Certificate" /> -->
<!-- 				</text> -->
<!-- 			</xsl:if> -->
<!-- 		</rect> -->
<!-- 		<xsl:apply-templates select="diag:Revocations/diag:CertificateRevocation"/> -->
<!-- 	</xsl:template> -->
	
 
</xsl:stylesheet>
