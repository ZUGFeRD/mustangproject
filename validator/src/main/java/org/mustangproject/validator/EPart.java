package org.mustangproject.validator;

/***
 * Identifies if an error occurs in the pdf or xml (and which kind of xml) part of the file
 * fx=factur-x
 * ox=order-x
 * xr=xrechnung
 */
public enum EPart {
	fx, ox, xr, pdf, none
}
