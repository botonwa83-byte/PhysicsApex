import SwiftUI
import WebKit

// MARK: - Public API (SwiftUI View)

struct FormulaView: View {
    let latex: String
    let displayMode: Bool
    let fontSize: CGFloat

    @State private var dynamicHeight: CGFloat = 44

    init(latex: String, displayMode: Bool = true, fontSize: CGFloat = 18) {
        self.latex = latex
        self.displayMode = displayMode
        self.fontSize = fontSize
    }

    var body: some View {
        FormulaWebView(
            latex: latex,
            displayMode: displayMode,
            fontSize: fontSize,
            dynamicHeight: $dynamicHeight
        )
        .frame(height: dynamicHeight)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Internal WKWebView wrapper

private struct FormulaWebView: UIViewRepresentable {
    let latex: String
    let displayMode: Bool
    let fontSize: CGFloat
    @Binding var dynamicHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(dynamicHeight: $dynamicHeight)
    }

    /// 所有公式 webview 共享同一个进程池，避免每个公式各起一个 WebContent 进程导致内存膨胀、被系统 SIGKILL。
    private static let sharedProcessPool = WKProcessPool()

    func makeUIView(context: Context) -> WKWebView {
        let controller = WKUserContentController()
        controller.add(context.coordinator, name: "sizeReporter")

        let config = WKWebViewConfiguration()
        config.userContentController = controller
        config.processPool = FormulaWebView.sharedProcessPool
        if #available(iOS 16.4, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }

        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 320, height: 44), configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let escaped = escape(latex)
        let key = "\(escaped)|\(fontSize)|\(displayMode)"
        guard key != context.coordinator.lastKey else { return }
        context.coordinator.lastKey = key
        webView.loadHTMLString(html(escaped: escaped), baseURL: FormulaWebView.katexBaseURL)
    }

    /// 本地 KaTeX 资源目录(打包在 App Bundle 的 katex 文件夹)，离线渲染用。
    static let katexBaseURL: URL? = Bundle.main.url(forResource: "katex.min", withExtension: "css", subdirectory: "katex")?.deletingLastPathComponent()

    // MARK: HTML

    private func html(escaped: String) -> String {
        """
        <!DOCTYPE html><html><head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
        <style>
        *{margin:0;padding:0;box-sizing:border-box}
        html{background:transparent}
        body{
          background:transparent;
          padding:4px 2px;
          /* NO overflow hidden — let content be measured fully */
        }
        #formula{
          display:block;
          width:100%;
          word-wrap:break-word;
          overflow-wrap:break-word;
        }
        .katex{
          font-size:\(fontSize)px !important;
          text-align:left;
          white-space:normal !important;
        }
        .katex-display{
          margin:0 !important;
          padding:2px 0 !important;
          text-align:left;
          overflow-x:auto;
          overflow-y:visible;
          -webkit-overflow-scrolling:touch;
        }
        .katex-display>.katex{
          text-align:left;
          white-space:normal !important;
        }
        .katex-html{
          white-space:normal !important;
        }
        @media(prefers-color-scheme:dark){
          .katex,.katex *{color:#E0E0E0 !important}
        }
        @media(prefers-color-scheme:light){
          .katex,.katex *{color:#1C1C1E !important}
        }
        </style>
        <link rel="stylesheet" href="katex.min.css">
        <script defer src="katex.min.js"></script>
        <script>
        function doRender(){
          var el=document.getElementById('formula');
          try{
            katex.render('\(escaped)',el,{
              displayMode:\(displayMode),
              throwOnError:false,
              strict:false,
              trust:true,
              output:'html'
            });
          }catch(e){
            el.textContent='\(escaped)';
            el.style.fontFamily='monospace';
            el.style.fontSize='\(fontSize)px';
            el.style.wordBreak='break-all';
          }
          reportHeight();
        }
        function reportHeight(){
          // Use requestAnimationFrame twice to ensure layout is done
          requestAnimationFrame(function(){
            requestAnimationFrame(function(){
              var h=document.body.scrollHeight;
              if(h>0){
                window.webkit.messageHandlers.sizeReporter.postMessage(h);
              }
            });
          });
        }
        // Wait for KaTeX to load
        (function waitAndRender(){
          if(typeof katex!=='undefined'){doRender();return;}
          var s=document.querySelector('script[src*="katex.min"]');
          if(s){s.addEventListener('load',doRender);return;}
          var t=setInterval(function(){
            if(typeof katex!=='undefined'){clearInterval(t);doRender();}
          },50);
          setTimeout(function(){clearInterval(t);doRender();},4000);
        })();
        </script>
        </head>
        <body><div id="formula"></div></body>
        </html>
        """
    }

    // MARK: Escape

    private func escape(_ s: String) -> String {
        s.replacingOccurrences(of: "\\", with: "\\\\")
         .replacingOccurrences(of: "'",  with: "\\'")
         .replacingOccurrences(of: "\"", with: "\\\"")
         .replacingOccurrences(of: "\n", with: "\\n")
         .replacingOccurrences(of: "\r", with: "\\r")
         .replacingOccurrences(of: "\t", with: "\\t")
         .replacingOccurrences(of: "<",  with: "\\u003C")
         .replacingOccurrences(of: ">",  with: "\\u003E")
         .replacingOccurrences(of: "&",  with: "\\u0026")
    }

    // MARK: Coordinator

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var lastKey: String?
        @Binding var dynamicHeight: CGFloat

        init(dynamicHeight: Binding<CGFloat>) {
            _dynamicHeight = dynamicHeight
        }

        func userContentController(_ controller: WKUserContentController,
                                   didReceive message: WKScriptMessage) {
            guard let h = message.body as? CGFloat, h > 0 else { return }
            let clamped = max(h, 20)
            DispatchQueue.main.async {
                if abs(self.dynamicHeight - clamped) > 1 {
                    self.dynamicHeight = clamped
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Backup measurement after full navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, _ in
                    guard let h = result as? CGFloat, h > 0 else { return }
                    let clamped = max(h, 20)
                    DispatchQueue.main.async {
                        if let self = self, abs(self.dynamicHeight - clamped) > 1 {
                            self.dynamicHeight = clamped
                        }
                    }
                }
            }
        }
    }
}
