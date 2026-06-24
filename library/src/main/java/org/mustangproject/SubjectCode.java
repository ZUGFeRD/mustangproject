package org.mustangproject;

/**
 * EN16931-ID: BT-21 - the qualification of the free text on the invoice from BT-22
 * @see <a href="https://service.unece.org/trade/untdid/d96a/uncl/uncl4451.htm">UNTDID - D.96A - Element 4451</a> for a complete list of codes
 *
 * In the first step only the recommended codes are implemented:
 * AAI : General information / Allgemeine Informationen
 * SUR : Supplier remarks / Anmerkungen des Verkäufers
 * REG : Regulatory information / Regulatorische Informationen
 * ABL : Government information / Rechtliche Informationen
 * TXD : Tax declaration / Informationen zur Steuer
 * CUS : Customs declaration information / Zollinformationen
 *
 * plus
 * ACY : Introduction
 * AAK : Price conditions
 * ABZ : Instructions/information about revolving documentary credit
 * PMT : Payment information
 * PMD : Payment detail/remittance information
 * AAB : Terms of payments
 * ACB : Additional information
 * INV : Invoice instruction
 */
public enum SubjectCode {
  /**
   * general information
   */
  AAI,
  /**
   * seller notes
   */
  SUR,
  /**
   * regulatory information
   */
  REG,
  /**
   * legal information
   */
  ABL,
  /**
   * tax information
   */
  TXD,
  /**
   * Customs information
   */
  CUS,
  /**
   * introduction
   */
  ACY,
  /**
   * Discount and bonus agreements
   */
  AAK,
  /**
   * Instructions/information about revolving documentary credit
   */
  ABZ,
  /**
   * Payment information
   */
  PMT,
  /**
   * Payment detail/remittance information
   */
  PMD,
  /**
   * Payment term
   */
  AAB,
  /**
   * Additional information
   */
  ACB,
  /**
   * Invoice instruction
   */
  INV

}
