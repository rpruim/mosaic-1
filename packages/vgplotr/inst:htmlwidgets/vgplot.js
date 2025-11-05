HTMLWidgets.widget({
  name: 'vgplot',
  type: 'output',
  
  factory: function(el, width, height) {
    let vg;
    let coordinator;
    
    return {
      renderValue: async function(x) {
        // Clear previous content
        el.innerHTML = '';
        
        // Import vgplot if not already done
        if (!vg) {
          vg = await import('https://cdn.jsdelivr.net/npm/@uwdata/vgplot@0.5.0/+esm');
          
          // Set up coordinator with WASM connector for client-side data
          const wasm = vg.wasmConnector();
          coordinator = vg.coordinator().databaseConnector(wasm);
        }
        
        // Register data if provided
        if (x.data && x.data.length > 0) {
          await coordinator.exec([
            vg.loadObjects("data", x.data)
          ]);
        }
        
        // Create plot elements
        const plotElements = [];
        
        // Add marks
        if (x.marks && x.marks.length > 0) {
          for (const markSpec of x.marks) {
            const mark = createMark(vg, markSpec);
            if (mark) {
              plotElements.push(mark);
            }
          }
        }
        
        // Add plot options
        if (x.options) {
          for (const [key, value] of Object.entries(x.options)) {
            if (key === 'width') {
              plotElements.push(vg.width(value));
            } else if (key === 'height') {
              plotElements.push(vg.height(value));
            }
            // Add more option handlers as needed
          }
        }
        
        // Create and render the plot
        if (plotElements.length > 0) {
          const plot = vg.plot(...plotElements);
          el.appendChild(plot);
        }
      },
      
      resize: function(width, height) {
        // Handle resize if needed
      }
    };
  }
});

// Helper function to create marks
function createMark(vg, markSpec) {
  const { mark, data, ...options } = markSpec;
  
  let markFn;
  switch (mark) {
    case 'dot':
      markFn = vg.dot;
      break;
    case 'line':
      markFn = vg.line;
      break;
    case 'barY':
      markFn = vg.barY;
      break;
    case 'areaY':
      markFn = vg.areaY;
      break;
    default:
      console.warn(`Unknown mark type: ${mark}`);
      return null;
  }
  
  // Handle data source
  let dataSource;
  if (typeof data === 'string') {
    dataSource = vg.from(data);
  } else if (data && data.from) {
    dataSource = vg.from(data.from);
  } else {
    dataSource = vg.from("data"); // Default data source
  }
  
  return markFn(dataSource, options);
}