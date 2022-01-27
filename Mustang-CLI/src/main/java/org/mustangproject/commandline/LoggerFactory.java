/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.commandline;


import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.encoder.PatternLayoutEncoder;
import ch.qos.logback.core.ConsoleAppender;
import ch.qos.logback.core.rolling.RollingFileAppender;
import ch.qos.logback.core.rolling.TimeBasedRollingPolicy;

public class LoggerFactory {
	protected static boolean createLogFile = false;
	public static void setCreateFile(boolean doCreate) {
		createLogFile=doCreate;
	}
	public static Logger getLogger(String classname) {
		/*
https://stackoverflow.com/questions/16910955/programmatically-configure-logback-appender
		 */
		LoggerContext lc = (LoggerContext) org.slf4j.LoggerFactory.getILoggerFactory();
		PatternLayoutEncoder ple = new PatternLayoutEncoder();

		ple.setPattern("%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n");
		ple.setContext(lc);
		ple.start();

		ConsoleAppender logConsoleAppender = new ConsoleAppender();
		logConsoleAppender.setContext(lc);
		logConsoleAppender.setName("console");
		logConsoleAppender.setEncoder(ple);
		logConsoleAppender.start();


		Logger logger = (Logger) org.slf4j.LoggerFactory.getLogger(classname);
		logger.addAppender(logConsoleAppender);

		logger.setLevel(Level.INFO);
		logger.setAdditive(true); /* set to true if root should log too */
		if (createLogFile) {
			RollingFileAppender logFileAppender = new RollingFileAppender();
			logFileAppender.setContext(lc);
			logFileAppender.setName("logFile");
			logFileAppender.setEncoder(ple);
			logFileAppender.setAppend(true);

			TimeBasedRollingPolicy logFilePolicy = new TimeBasedRollingPolicy();
			logFilePolicy.setContext(lc);
			logFilePolicy.setParent(logFileAppender);
			logFilePolicy.setFileNamePattern("log/ZUV-%d{yyyy-MM}.log");
			logFilePolicy.setMaxHistory(60);
			logFilePolicy.start();
			logFileAppender.setRollingPolicy(logFilePolicy);
			logFileAppender.start();
			logger.addAppender(logFileAppender);
		}

		return logger;
	}

}
