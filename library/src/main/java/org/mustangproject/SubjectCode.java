package org.mustangproject;

/**
 * EN16931-ID: BT-21 - the qualification of the free text on the invoice from BT-22
 * In the first step only the recommended codes are implemented. 
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
   * Vehicle licence number
   */
  ABZ
}
