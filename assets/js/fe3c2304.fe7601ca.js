"use strict";(self.webpackChunkdocusaurus=self.webpackChunkdocusaurus||[]).push([[423],{8600:(e,n,i)=>{i.r(n),i.d(n,{assets:()=>c,contentTitle:()=>l,default:()=>h,frontMatter:()=>a,metadata:()=>r,toc:()=>d});var s=i(4848),t=i(8453);const a={},l="Installing with Nix",r={id:"Installation/installing-with-nix",title:"Installing with Nix",description:"Nix is a purely functional package manager that creates",source:"@site/docs/Installation/installing-with-nix.md",sourceDirName:"Installation",slug:"/Installation/installing-with-nix",permalink:"/cardano-db-sync/Installation/installing-with-nix",draft:!1,unlisted:!1,editUrl:"https://github.com/sgillespie/cardano-db-sync/tree/docs/docusaurus/doc/docusaurus/docs/Installation/installing-with-nix.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Docker",permalink:"/cardano-db-sync/Installation/docker"},next:{title:"Installing with Cabal",permalink:"/cardano-db-sync/Installation/installing"}},c={},d=[{value:"Prerequisites",id:"prerequisites",level:2},{value:"Configure Nix",id:"configure-nix",level:2},{value:"Add the Binary Cache",id:"add-the-binary-cache",level:2},{value:"Download the Source",id:"download-the-source",level:2},{value:"Build and Install",id:"build-and-install",level:2}];function o(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",ul:"ul",...(0,t.R)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(n.h1,{id:"installing-with-nix",children:"Installing with Nix"}),"\n",(0,s.jsxs)(n.p,{children:[(0,s.jsx)(n.a,{href:"https://nixos.org/download.html",children:"Nix"})," is a purely functional package manager that creates\nreproducible, declarative and reliable systems. This is the only dependency required to\nbuild Cardano DB Sync."]}),"\n",(0,s.jsx)(n.h2,{id:"prerequisites",children:"Prerequisites"}),"\n",(0,s.jsx)(n.p,{children:"This guide assumes you have the following tools:"}),"\n",(0,s.jsxs)(n.ul,{children:["\n",(0,s.jsx)(n.li,{children:(0,s.jsx)(n.a,{href:"https://nixos.org/download.html",children:"Nix"})}),"\n",(0,s.jsx)(n.li,{children:(0,s.jsx)(n.a,{href:"https://github.com/IntersectMBO/cardano-node/blob/master/doc/getting-started/building-the-node-using-nix.md",children:"Cardano Node"})}),"\n"]}),"\n",(0,s.jsx)(n.p,{children:"Nix will handle all other dependencies."}),"\n",(0,s.jsx)(n.p,{children:"Create a working directory for your builds:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"mkdir -p ~/src\ncd ~/src\n"})}),"\n",(0,s.jsx)(n.h2,{id:"configure-nix",children:"Configure Nix"}),"\n",(0,s.jsxs)(n.p,{children:["Enable ",(0,s.jsx)(n.a,{href:"https://nixos.wiki/wiki/Flakes",children:"Flakes"})," (and IFD support):"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"sudo mkdir -p /etc/nix\ncat <<EOF | sudo tee /etc/nix/nix.conf\nexperimental-features = nix-command flakes\nallow-import-from-derivation = true\nEOF\n"})}),"\n",(0,s.jsxs)(n.p,{children:["Check ",(0,s.jsx)(n.a,{href:"https://nixos.wiki/wiki/Flakes#Enable_flakes",children:"this page"})," for further instructions."]}),"\n",(0,s.jsx)(n.h2,{id:"add-the-binary-cache",children:"Add the Binary Cache"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"sudo mkdir -p /etc/nix\ncat <<EOF | sudo tee -a /etc/nix/nix.conf\nsubstituters = https://cache.nixos.org https://cache.iog.io\ntrusted-public-keys = cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=\nEOF\n"})}),"\n",(0,s.jsx)(n.h2,{id:"download-the-source",children:"Download the Source"}),"\n",(0,s.jsx)(n.p,{children:"Enter the working directory for your builds:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"cd ~/src\n"})}),"\n",(0,s.jsxs)(n.p,{children:["Find the latest release here: ",(0,s.jsx)(n.a,{href:"https://github.com/IntersectMBO/cardano-db-sync/releases",children:"https://github.com/IntersectMBO/cardano-db-sync/releases"})]}),"\n",(0,s.jsx)(n.p,{children:"Check out the latest release version:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"git clone https://github.com/IntersectMBO/cardano-db-sync.git\ncd cardano-db-sync\ngit fetch --all --tags\ngit checkout tags/<VERSION>\n"})}),"\n",(0,s.jsx)(n.h2,{id:"build-and-install",children:"Build and Install"}),"\n",(0,s.jsxs)(n.p,{children:["Build Cardano DB Sync with ",(0,s.jsx)(n.code,{children:"nix"}),":"]}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"nix build .\n"})}),"\n",(0,s.jsxs)(n.p,{children:["This will build the executable and link it in ",(0,s.jsx)(n.code,{children:"./result"}),"."]}),"\n",(0,s.jsx)(n.p,{children:"Install it in your nix proile:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"nix profile install .\n"})}),"\n",(0,s.jsx)(n.p,{children:"Check the version that has been installed:"}),"\n",(0,s.jsx)(n.pre,{children:(0,s.jsx)(n.code,{className:"language-bash",children:"cardano-db-sync --version\n"})})]})}function h(e={}){const{wrapper:n}={...(0,t.R)(),...e.components};return n?(0,s.jsx)(n,{...e,children:(0,s.jsx)(o,{...e})}):o(e)}},8453:(e,n,i)=>{i.d(n,{R:()=>l,x:()=>r});var s=i(6540);const t={},a=s.createContext(t);function l(e){const n=s.useContext(a);return s.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function r(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:l(e.components),s.createElement(a.Provider,{value:n},e.children)}}}]);