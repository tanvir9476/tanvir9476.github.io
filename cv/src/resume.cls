%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Medium Length Professional CV - RESUME CLASS FILE
%
% This template has been downloaded from:
% http://www.LaTeXTemplates.com
%
% This class file defines the structure and design of the template. 
%
% Original header:
% Copyright (C) 2010 by Trey Hunner
%
% Copying and distribution of this file, with or without modification,
% are permitted in any medium without royalty provided the copyright
% notice and this notice are preserved. This file is offered as-is,
% without any warranty.
%
% Created by Trey Hunner and modified by www.LaTeXTemplates.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

\LoadClass[11pt,letterpaper]{article} % Font size and paper type

\usepackage[parfill]{parskip} % Remove paragraph indentation
\usepackage{array} % Required for boldface (\bf and \bfseries) tabular columns
\usepackage{tabularx} % Wrapping degree titles with right-aligned dates
\usepackage{needspace} % Keep entry headings with their opening details
\usepackage{ifthen} % Required for ifthenelse statements

\pagestyle{empty} % Suppress page numbers

%----------------------------------------------------------------------------------------
%	HEADINGS COMMANDS: Commands for printing name and address
%----------------------------------------------------------------------------------------

\def \name#1{\def\@name{#1}} % Defines the \name command to set name
\def \@name {} % Sets \@name to empty by default

\def \addressSep {$\cdot$} % Set default address separator to a diamond

% One, two or three address lines can be specified 
\let \@addressone \relax
\let \@addresstwo \relax
\let \@addressthree \relax

% \address command can be used to set the first, second, and third address (last 2 optional)
\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
  \@ifundefined{@addressthree}{
  \def \@addressthree {#1}
  }{
     \def \@addressone {#1}
  }}
}

% \printaddress is used to style an address line (given as input)
\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    \centerline{#1}
  \endgroup
  \par
  \addressskip
}

% \printname is used to print the name as a page header
\def \printname {
  \begingroup
    \hfil{\MakeUppercase{\namesize\bf \@name}}\hfil
    \nameskip\break
  \endgroup
}

%----------------------------------------------------------------------------------------
%	PRINT THE HEADING LINES
%----------------------------------------------------------------------------------------

\let\ori@document=\document
\renewcommand{\document}{
  \ori@document  % Begin document
  \printname % Print the name specified with \name
  \@ifundefined{@addressone}{}{ % Print the first address if specified
    \printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{ % Print the second address if specified
    \printaddress{\@addresstwo}}
     \@ifundefined{@addressthree}{}{ % Print the third address if specified
    \printaddress{\@addressthree}}
}

%----------------------------------------------------------------------------------------
%	SECTION FORMATTING
%----------------------------------------------------------------------------------------

% Defines the rSection environment for the large sections within the CV
\newenvironment{rSection}[1]{ % 1 input argument - section name
  \sectionskip
  \MakeUppercase{\bf #1} % Section title
  \sectionlineskip
  \hrule % Horizontal line
  \begin{list}{}{ % List for each individual item in the section
    \setlength{\leftmargin}{1.5em} % Margin within the section
  }
  \item[]
}{
  \end{list}
}

%----------------------------------------------------------------------------------------
% EDUCATION FORMATTING
%----------------------------------------------------------------------------------------

% One institution heading can contain multiple degree rows and optional details.
\newenvironment{rEducationSubsection}[2]{ % Institution and location
  \par
  \normalfont
  \setlength{\parskip}{0pt}
  \addvspace{0.5em}
  \noindent\textbf{#1}\hfill #2\par
  \nopagebreak[4]\smallskip
}{
  \par\addvspace{0.5em}
}

\newcommand{\educationDegree}[3][]{ % Optional metadata, degree, and date
  \par\addvspace{0.3em}
  \noindent\makebox[0.8em][l]{$\cdot$}\begin{tabularx}{\dimexpr\linewidth-0.8em\relax}{@{}X r@{}}
    #2\ifthenelse{\equal{#1}{}}{}{\hspace{0.5em}{\small (#1)}} & #3 \\
  \end{tabularx}\par
  \nopagebreak[3]
}

\newenvironment{educationDetails}[1][0.5em]{ % Optional space around the detail block
  \small
  \begin{list}{}{
    \setlength{\leftmargin}{1.8em}
    \setlength{\labelwidth}{0pt}
    \setlength{\labelsep}{0pt}
    \setlength{\topsep}{#1}
    \setlength{\partopsep}{0pt}
    \setlength{\parsep}{0pt}
    \setlength{\itemsep}{0pt}
  }
}{
  \end{list}
}

%----------------------------------------------------------------------------------------
% PUBLICATION AND DEMO FORMATTING
%----------------------------------------------------------------------------------------

% Title at the section margin, authors one level in, details two levels in.
\newenvironment{rPublicationSubsection}[4]{ % Title, heading suffix, authors, links
  \par\Needspace{5\baselineskip}
  \setlength{\parskip}{0pt}
  \addvspace{0.5em}
  \noindent\textbf{#1}\hfill #2\par
  \nopagebreak[4]
  \noindent\hspace*{0.8em}\begin{tabularx}{\dimexpr\linewidth-0.8em\relax}{@{}X r@{}}
    #3 & #4 \\
  \end{tabularx}\par
  \nopagebreak[4]
  \begin{list}{$\cdot$}{
    \setlength{\leftmargin}{1.8em}
    \setlength{\labelwidth}{0.3em}
    \setlength{\labelsep}{0.5em}
    \setlength{\topsep}{0.15em}
    \setlength{\partopsep}{0pt}
    \setlength{\parsep}{0pt}
    \setlength{\itemsep}{0pt}
  }
}{
  \end{list}
  \par\addvspace{0.5em}
}

% Work entries share Education's organization -> role -> detail hierarchy.
\newenvironment{rExperienceSubsection}[2]{ % Organization and location
  \par\Needspace{5\baselineskip}
  \begin{rEducationSubsection}{#1}{#2}
}{
  \end{rEducationSubsection}
}

\newcommand{\experienceRole}[2]{\educationDegree{#1}{#2}}

\newenvironment{experienceDetails}{
  \begin{educationDetails}[0.15em]
}{
  \end{educationDetails}
}

%----------------------------------------------------------------------------------------
%	WORK EXPERIENCE FORMATTING
%----------------------------------------------------------------------------------------

\newenvironment{rSubsection}[4]{ % 4 input arguments - company name, year(s) employed, job title and location
 \Needspace{5\baselineskip}
 {\bf #1} \hfill {#2} % Bold company name and date on the right
 \ifthenelse{\equal{#3}{}}{}{ % If the third argument is not specified, don't print the job title and location line
  \\
  {#3} \hfill {#4} % Italic job title and location
  }\smallskip
  \begin{list}{$\cdot$}{\leftmargin=0em} % \cdot used for bullets, no indentation
   \itemsep -0.5em \vspace{-0.5em} % Compress items in list together for aesthetics
  }{
  \end{list}
  \vspace{0.5em} % Some space after the list of bullet points
}

% The below commands define the whitespace after certain things in the document - they can be \smallskip, \medskip or \bigskip
\def\namesize{\huge} % Size of the name at the top of the document
\def\addressskip{\smallskip} % The space between the two address (or phone/email) lines
\def\sectionlineskip{\medskip} % The space above the horizontal line for each section 
\def\nameskip{\bigskip} % The space after your name at the top
\def\sectionskip{\medskip} % The space after the heading section
