function attributeNameMatchesPrefix(attributeName, prefix) {
  return attributeName.indexOf(`data-${prefix}-`) === 0;
}
function attributeNameToViewName(attributeName) {
  return attributeName.split("-").slice(2).map((part, index) => {
    return index > 0 ? capitalize(part) : part;
  }).join("");
}
function datasetKeysForPrefix(node, prefix) {
  return Object.keys(node.dataset).filter((key) => key.indexOf(prefix) === 0);
}
function hasDatasetKeysMatchingPrefix(node, prefix) {
  return datasetKeysForPrefix(node, prefix).length > 0;
}
function keyForDataset(prefix, viewName) {
  return `${lowerFirsterize(prefix)}${capitalize(viewName)}`;
}
function dasherize(str) {
  const pattern = /([a-z0-9])([A-Z])/g;
  return str.replace(pattern, "$1-$2").toLowerCase();
}
function lowerFirsterize(str) {
  return str.replace(/^[_.\- ]+/, "").toLowerCase().replace(/[_.\- ]+(\w|$)/g, (_, p1) => p1.toUpperCase()).replace(/\d+(\w|$)/g, (m) => m.toUpperCase());
}
function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}
function parseProps(value) {
  try {
    return JSON.parse(value);
  } catch (err) {
    if (value.startsWith("{")) {
      console.error(`Failed to parse suspected JSON props: ${value}`);
    }
  }
  return value;
}
function createEventHelpers(node) {
  const controller = new AbortController();
  const { signal } = controller;
  const on = (...args) => {
    let target = node;
    let rest = args;
    if (typeof rest[0] !== "string") {
      target = rest[0];
      rest = rest.slice(1);
    }
    const [type, second, third, fourth] = rest;
    if (typeof second === "string") {
      const selector = second;
      const handler = third;
      const options = fourth;
      target.addEventListener(type, delegate(target, selector, handler), {
        ...options,
        signal
      });
    } else {
      const handler = second;
      const options = third;
      target.addEventListener(type, handler, { ...options, signal });
    }
  };
  return {
    on,
    signal,
    destroy: () => controller.abort()
  };
}
function delegate(root, selector, handler) {
  return (event) => {
    let candidate = event.target;
    while (candidate && candidate !== root) {
      if (candidate.matches?.(selector)) {
        handler(event, candidate);
        return;
      }
      candidate = candidate.parentElement;
    }
  };
}
function renderTree({
  prefix,
  scope,
  views
}) {
  Object.keys(views).forEach((viewName) => {
    const attrName = `data-${prefix}-${dasherize(viewName)}`;
    let nodes = Array.prototype.slice.call(
      scope.querySelectorAll(`[${attrName}]`)
    );
    if (scope.hasAttribute(attrName)) {
      nodes = [scope].concat(nodes);
    }
    nodes.forEach((node) => {
      renderViewForNode(node, prefix, views, viewName);
    });
  });
}
function renderViewForNode(node, prefix, views, viewName) {
  if (node._defoUpdate && node._defoUpdate[viewName]) {
    return;
  }
  const viewFunction = views[viewName];
  const datasetkey = keyForDataset(prefix, viewName);
  if (!viewFunction || !(datasetkey in node.dataset)) {
    return;
  }
  const dataValue = node.dataset[datasetkey];
  const events = createEventHelpers(node);
  const returnValue = viewFunction(
    node,
    dataValue ? parseProps(dataValue) : void 0,
    { on: events.on, signal: events.signal }
  );
  node._defoUpdate = node._defoUpdate || {};
  node._defoDestroy = node._defoDestroy || {};
  node._defoUpdate[viewName] = unwrapUpdate(returnValue);
  node._defoDestroy[viewName] = unwrapDestroy(
    returnValue,
    node,
    viewName,
    events.destroy
  );
}
function unwrapUpdate(returnValue) {
  return function(newProps, prevProps) {
    const resolvedNewProps = newProps ? parseProps(newProps) : newProps;
    const resolvedPrevProps = prevProps ? parseProps(prevProps) : prevProps;
    Promise.resolve(returnValue).then((resolvedReturnValue) => {
      if (resolvedReturnValue && resolvedReturnValue.update) {
        resolvedReturnValue.update(resolvedNewProps, resolvedPrevProps);
      }
    });
  };
}
function unwrapDestroy(returnValue, node, viewName, destroyEvents) {
  return function() {
    Promise.resolve(returnValue).then((resolvedReturnValue) => {
      destroyEvents();
      resolvedReturnValue?.destroy?.();
      if (node._defoUpdate) {
        delete node._defoUpdate[viewName];
      }
      if (node._defoDestroy) {
        delete node._defoDestroy[viewName];
      }
    });
  };
}
function observe({
  prefix,
  scope,
  views
}) {
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      const target = mutation.target;
      if (mutation.type === "attributes" && mutation.attributeName !== null && attributeNameMatchesPrefix(mutation.attributeName, prefix)) {
        const viewName = attributeNameToViewName(mutation.attributeName);
        if (!target.hasAttribute(mutation.attributeName)) {
          target._defoDestroy?.[viewName]?.();
        } else if (mutation.oldValue !== null) {
          const attributeValue = target.getAttribute(mutation.attributeName);
          if (attributeValue !== null) {
            target._defoUpdate?.[viewName]?.(attributeValue, mutation.oldValue);
          }
        } else {
          renderViewForNode(target, prefix, views, viewName);
        }
      } else if (mutation.type === "childList") {
        Array.prototype.slice.call(mutation.removedNodes).filter((node) => {
          return node.nodeType === node.ELEMENT_NODE;
        }).filter(
          (node) => hasDatasetKeysMatchingPrefix(node, prefix)
        ).forEach((node) => {
          if (node._defoDestroy) {
            Object.keys(node._defoDestroy).forEach((key) => {
              node._defoDestroy?.[key]?.();
            });
          }
        });
        Array.prototype.slice.call(mutation.addedNodes).filter((node) => {
          return node.nodeType === node.ELEMENT_NODE;
        }).forEach((node) => {
          Promise.resolve(node).then((resolvedNode) => {
            renderTree({ prefix, scope: resolvedNode, views });
          });
        });
      }
    });
  });
  observer.observe(scope, {
    attributes: true,
    attributeOldValue: true,
    childList: true,
    characterData: false,
    subtree: true
  });
  renderTree({ prefix, scope, views });
  return observer;
}
function defo({
  prefix = "defo",
  scope = document.documentElement,
  views = {}
} = {}) {
  const observer = observe({ prefix, scope, views });
  return {
    destroy: () => {
      observer.disconnect();
    }
  };
}
export {
  defo as default
};
//# sourceMappingURL=index.js.map
