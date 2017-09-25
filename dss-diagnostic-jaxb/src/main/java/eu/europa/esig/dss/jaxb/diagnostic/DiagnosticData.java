//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.7 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.09.25 at 07:40:48 AM CEST 
//


package eu.europa.esig.dss.jaxb.diagnostic;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="DocumentName" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ValidationDate" type="{http://www.w3.org/2001/XMLSchema}dateTime"/>
 *         &lt;element name="ContainerInfo" type="{http://dss.esig.europa.eu/validation/diagnostic}ContainerInfo" minOccurs="0"/>
 *         &lt;element name="Signatures" minOccurs="0">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="Signature" type="{http://dss.esig.europa.eu/validation/diagnostic}Signature" maxOccurs="unbounded" minOccurs="0"/>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="UsedCertificates" minOccurs="0">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="Certificate" type="{http://dss.esig.europa.eu/validation/diagnostic}Certificate" maxOccurs="unbounded" minOccurs="0"/>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="TrustedLists" minOccurs="0">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="TrustedList" type="{http://dss.esig.europa.eu/validation/diagnostic}TrustedList" maxOccurs="unbounded" minOccurs="0"/>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="ListOfTrustedLists" type="{http://dss.esig.europa.eu/validation/diagnostic}TrustedList" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "documentName",
    "validationDate",
    "containerInfo",
    "signatures",
    "usedCertificates",
    "trustedLists",
    "listOfTrustedLists"
})
@XmlRootElement(name = "DiagnosticData")
public class DiagnosticData {

    @XmlElement(name = "DocumentName", required = true)
    protected String documentName;
    @XmlElement(name = "ValidationDate", required = true, type = String.class)
    @XmlJavaTypeAdapter(Adapter1 .class)
    @XmlSchemaType(name = "dateTime")
    protected Date validationDate;
    @XmlElement(name = "ContainerInfo")
    protected XmlContainerInfo containerInfo;
    @XmlElementWrapper(name = "Signatures")
    @XmlElement(name = "Signature", namespace = "http://dss.esig.europa.eu/validation/diagnostic")
    protected List<XmlSignature> signatures;
    @XmlElementWrapper(name = "UsedCertificates")
    @XmlElement(name = "Certificate", namespace = "http://dss.esig.europa.eu/validation/diagnostic")
    protected List<XmlCertificate> usedCertificates;
    @XmlElementWrapper(name = "TrustedLists")
    @XmlElement(name = "TrustedList", namespace = "http://dss.esig.europa.eu/validation/diagnostic")
    protected List<XmlTrustedList> trustedLists;
    @XmlElement(name = "ListOfTrustedLists")
    protected XmlTrustedList listOfTrustedLists;

    /**
     * Gets the value of the documentName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDocumentName() {
        return documentName;
    }

    /**
     * Sets the value of the documentName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDocumentName(String value) {
        this.documentName = value;
    }

    /**
     * Gets the value of the validationDate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public Date getValidationDate() {
        return validationDate;
    }

    /**
     * Sets the value of the validationDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setValidationDate(Date value) {
        this.validationDate = value;
    }

    /**
     * Gets the value of the containerInfo property.
     * 
     * @return
     *     possible object is
     *     {@link XmlContainerInfo }
     *     
     */
    public XmlContainerInfo getContainerInfo() {
        return containerInfo;
    }

    /**
     * Sets the value of the containerInfo property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlContainerInfo }
     *     
     */
    public void setContainerInfo(XmlContainerInfo value) {
        this.containerInfo = value;
    }

    /**
     * Gets the value of the listOfTrustedLists property.
     * 
     * @return
     *     possible object is
     *     {@link XmlTrustedList }
     *     
     */
    public XmlTrustedList getListOfTrustedLists() {
        return listOfTrustedLists;
    }

    /**
     * Sets the value of the listOfTrustedLists property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlTrustedList }
     *     
     */
    public void setListOfTrustedLists(XmlTrustedList value) {
        this.listOfTrustedLists = value;
    }

    public List<XmlSignature> getSignatures() {
        if (signatures == null) {
            signatures = new ArrayList<XmlSignature>();
        }
        return signatures;
    }

    public void setSignatures(List<XmlSignature> signatures) {
        this.signatures = signatures;
    }

    public List<XmlCertificate> getUsedCertificates() {
        if (usedCertificates == null) {
            usedCertificates = new ArrayList<XmlCertificate>();
        }
        return usedCertificates;
    }

    public void setUsedCertificates(List<XmlCertificate> usedCertificates) {
        this.usedCertificates = usedCertificates;
    }

    public List<XmlTrustedList> getTrustedLists() {
        if (trustedLists == null) {
            trustedLists = new ArrayList<XmlTrustedList>();
        }
        return trustedLists;
    }

    public void setTrustedLists(List<XmlTrustedList> trustedLists) {
        this.trustedLists = trustedLists;
    }

}
