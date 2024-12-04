/**
 * *********************************************************************
 * <p>
 * Copyright (c) 2024 Jan N. Klug
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject.util;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

/**
 * The {@link NodeMap} contains a {@link Map} representation of DOM object
 * It can be constructed either from the children of a single {@link Node} or a {@link NodeList}.
 */
public class NodeMap {
	private final Map<String, List<Node>> map = new HashMap<>();

	/**
	 * Create a new {@link NodeMap}
	 * The {@link Node} that is passed to the constructor must not be null.
	 * The {@link NodeMap} will be empty when no child nodes are present.
	 *
	 * @param node the node that shall be represented by this {@link NodeMap}
	 * @throws IllegalArgumentException when argument is null
	 */
	public NodeMap(Node node) {
		if (node == null) {
			throw new IllegalArgumentException("node cannot be null");
		}
		if (node.hasChildNodes()) {
			mapNodeList(node.getChildNodes());
		}
	}

	public NodeMap(NodeList nodeList) {
		if (nodeList == null) {
			throw new IllegalArgumentException("nodeList cannot be null");
		}
		mapNodeList(nodeList);
	}

	/**
	 * Get matching node by {@code LocalName}
	 * In case more than one node matches, it is not guaranteed that the first match is selected
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return the matching node
	 */
	public Optional<Node> getNode(String... localNames) {
		return getAllNodes(localNames).findAny();
	}

	/**
	 * Get a {@link NodeMap} of the child of a matching node by {@code LocalName}
	 * In case more than one node matches, it is not guaranteed that the first match is selected
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return the {@link NodeMap} representation of the matching node
	 */
	public Optional<NodeMap> getAsNodeMap(String... localNames) {
		return getNode(localNames).filter(Node::hasChildNodes).map(NodeMap::new);
	}

	/**
	 * Get the text content of a matching node
	 * In case more than one node matches, it is not guaranteed that the first match is selected
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return the text content of the matching node
	 */
	public Optional<String> getAsString(String... localNames) {
		return getNode(localNames).map(Node::getTextContent);
	}

	/**
	 * Get the text content of a matching node
	 * In case more than one node matches, it is not guaranteed that the first match is selected
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return the text content of the matching node, converted to BigDecimal
	 */
	public Optional<BigDecimal> getAsBigDecimal(String... localNames) {
		return getNode(localNames).map(Node::getTextContent).map(s->{
			try {
				return new BigDecimal(s.trim());
			} catch (NumberFormatException e) {
				return null;
			}

		});
	}

	/**
	 * Get the text content of a matching node
	 * In case more than one node matches, it is not guaranteed that the first match is selected
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return the text content of the matching node or {@code null} when no matching node could be found
	 */
	public String getAsStringOrNull(String... localNames) {
		return getAsString(localNames).orElse(null);
	}

	/**
	 * Get all matching nodes
	 *
	 * @param localNames one or more {@code LocalName}s
	 * @return a {@code Stream} that contains all matching nodes (can be empty if nothing matches)
	 */
	public Stream<Node> getAllNodes(String... localNames) {
		List<String> localNamesList = Arrays.asList(localNames);
		return map.entrySet().stream().filter(e -> localNamesList.contains(e.getKey())).flatMap(e -> e.getValue().stream());
	}

	private void mapNodeList(NodeList nodeList) {
		IntStream.range(0, nodeList.getLength()).mapToObj(nodeList::item)
			.filter(node -> node != null && node.getLocalName() != null)
			.forEach(node -> map.computeIfAbsent(node.getLocalName(), k -> new ArrayList<>()).add(node));
	}

	@Override
	public String toString() {
		return map.toString();
	}
}
