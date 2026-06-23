import 'package:flutter/material.dart';

enum AppLocale { es, en }

extension AppLocaleX on AppLocale {
  String get code => this == AppLocale.es ? 'es' : 'en';
  String get toggleLabel => this == AppLocale.es ? 'EN' : 'ES';
}

class LocalizedText {
  const LocalizedText({
    required this.es,
    required this.en,
  });

  final String es;
  final String en;

  String of(AppLocale locale) => locale == AppLocale.es ? es : en;
}

class ProfileData {
  const ProfileData({
    required this.name,
    required this.role,
    required this.heroTitle,
    required this.heroBody,
    required this.about,
    required this.location,
    required this.email,
    required this.githubUsername,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.cvFileName,
    required this.highlights,
    required this.stack,
  });

  final String name;
  final LocalizedText role;
  final LocalizedText heroTitle;
  final LocalizedText heroBody;
  final LocalizedText about;
  final String location;
  final String email;
  final String githubUsername;
  final String githubUrl;
  final String linkedinUrl;
  final String cvFileName;
  final List<LocalizedText> highlights;
  final List<String> stack;
}

class AppStrings {
  const AppStrings({
    required this.navWork,
    required this.navCv,
    required this.navContact,
    required this.ctaProjects,
    required this.ctaCv,
    required this.ctaDownloadCv,
    required this.ctaViewProject,
    required this.ctaSourceCode,
    required this.ctaLiveDemo,
    required this.sectionAbout,
    required this.sectionProjects,
    required this.sectionCv,
    required this.sectionContact,
    required this.projectsEyebrow,
    required this.projectsBody,
    required this.cvEyebrow,
    required this.cvPreviewBody,
    required this.contactBody,
    required this.projectChallenge,
    required this.projectSolution,
    required this.projectImpact,
    required this.projectStack,
    required this.cvPageIntro,
    required this.cvToc,
    required this.cvBackHome,
    required this.githubStars,
    required this.githubUpdated,
    required this.githubUnavailable,
    required this.footerLine,
  });

  final LocalizedText navWork;
  final LocalizedText navCv;
  final LocalizedText navContact;
  final LocalizedText ctaProjects;
  final LocalizedText ctaCv;
  final LocalizedText ctaDownloadCv;
  final LocalizedText ctaViewProject;
  final LocalizedText ctaSourceCode;
  final LocalizedText ctaLiveDemo;
  final LocalizedText sectionAbout;
  final LocalizedText sectionProjects;
  final LocalizedText sectionCv;
  final LocalizedText sectionContact;
  final LocalizedText projectsEyebrow;
  final LocalizedText projectsBody;
  final LocalizedText cvEyebrow;
  final LocalizedText cvPreviewBody;
  final LocalizedText contactBody;
  final LocalizedText projectChallenge;
  final LocalizedText projectSolution;
  final LocalizedText projectImpact;
  final LocalizedText projectStack;
  final LocalizedText cvPageIntro;
  final LocalizedText cvToc;
  final LocalizedText cvBackHome;
  final LocalizedText githubStars;
  final LocalizedText githubUpdated;
  final LocalizedText githubUnavailable;
  final LocalizedText footerLine;
}

const profileData = ProfileData(
  name: 'Enri DV',
  role: LocalizedText(
    es: 'Flutter Developer · Full-Stack Builder',
    en: 'Flutter Developer · Full-Stack Builder',
  ),
  heroTitle: LocalizedText(
    es: 'Construyo experiencias web y mobile con una base visual fuerte.',
    en: 'I build web and mobile experiences with a strong visual point of view.',
  ),
  heroBody: LocalizedText(
    es:
        'Este portafolio está pensado para mostrar proyectos reales, criterio de producto y una forma clara de resolver problemas con código.',
    en:
        'This portfolio is designed to showcase real projects, product thinking, and a clear way of solving problems with code.',
  ),
  about: LocalizedText(
    es:
        'Me enfoco en interfaces modernas, experiencias fluidas y productos que se sienten cuidados tanto por dentro como por fuera.',
    en:
        'I focus on modern interfaces, fluid experiences, and products that feel polished inside and out.',
  ),
  location: 'Bolivia · Remote friendly',
  email: 'enri.dev.contact@gmail.com',
  githubUsername: 'EnriDv',
  githubUrl: 'https://github.com/EnriDv',
  linkedinUrl: 'https://www.linkedin.com/in/enri-dv/',
  cvFileName: 'EnriDV-CV.pdf',
  highlights: [
    LocalizedText(
      es: 'UI con intención visual, no solo layouts funcionales.',
      en: 'UI with intention, not just functional layouts.',
    ),
    LocalizedText(
      es: 'Consumo APIs, modelo datos y dejo el producto listo para crecer.',
      en: 'I connect APIs, model data, and leave products ready to grow.',
    ),
    LocalizedText(
      es: 'Trabajo cómodo entre frontend, lógica de negocio y experiencia de usuario.',
      en: 'I work comfortably across frontend, business logic, and user experience.',
    ),
  ],
  stack: [
    'Flutter',
    'Dart',
    'Firebase',
    'Node.js',
    'TypeScript',
    'PostgreSQL',
    'REST APIs',
    'GitHub Actions',
  ],
);

const appStrings = AppStrings(
  navWork: LocalizedText(es: 'Proyectos', en: 'Projects'),
  navCv: LocalizedText(es: 'CV', en: 'Resume'),
  navContact: LocalizedText(es: 'Contacto', en: 'Contact'),
  ctaProjects: LocalizedText(es: 'Ver proyectos', en: 'See projects'),
  ctaCv: LocalizedText(es: 'Abrir CV', en: 'Open resume'),
  ctaDownloadCv: LocalizedText(es: 'Descargar PDF', en: 'Download PDF'),
  ctaViewProject: LocalizedText(es: 'Ver detalle', en: 'View details'),
  ctaSourceCode: LocalizedText(es: 'Código fuente', en: 'Source code'),
  ctaLiveDemo: LocalizedText(es: 'Demo', en: 'Live demo'),
  sectionAbout: LocalizedText(es: 'Sobre mí', en: 'About'),
  sectionProjects: LocalizedText(es: 'Proyectos', en: 'Projects'),
  sectionCv: LocalizedText(es: 'CV', en: 'Resume'),
  sectionContact: LocalizedText(es: 'Contacto', en: 'Contact'),
  projectsEyebrow: LocalizedText(
    es: 'Proyectos seleccionados',
    en: 'Selected work',
  ),
  projectsBody: LocalizedText(
    es:
        'Una selección curada para mostrar producto, arquitectura y experiencia visual sin depender solo del README.',
    en:
        'A curated selection built to show product thinking, architecture, and visual craft beyond the README.',
  ),
  cvEyebrow: LocalizedText(
    es: 'CV legible y exportable',
    en: 'Readable and exportable resume',
  ),
  cvPreviewBody: LocalizedText(
    es:
        'El CV vive en Markdown para poder mostrarlo bonito en web y generar un PDF descargable desde la misma fuente.',
    en:
        'The resume lives in Markdown so it can be rendered beautifully on the web and exported as a downloadable PDF from the same source.',
  ),
  contactBody: LocalizedText(
    es:
        'Si te interesa trabajar conmigo o revisar más a fondo algún proyecto, aquí tienes las vías directas.',
    en:
        'If you are interested in working with me or reviewing a project in more depth, here are the direct channels.',
  ),
  projectChallenge: LocalizedText(es: 'Problema', en: 'Challenge'),
  projectSolution: LocalizedText(es: 'Solución', en: 'Solution'),
  projectImpact: LocalizedText(es: 'Resultado', en: 'Outcome'),
  projectStack: LocalizedText(es: 'Stack', en: 'Stack'),
  cvPageIntro: LocalizedText(
    es:
        'Una versión web legible del CV, pensada para recruiters y clientes, con descarga directa en PDF.',
    en:
        'A readable web version of the resume, designed for recruiters and clients, with direct PDF download.',
  ),
  cvToc: LocalizedText(es: 'Índice', en: 'Contents'),
  cvBackHome: LocalizedText(es: 'Volver al inicio', en: 'Back home'),
  githubStars: LocalizedText(es: 'stars', en: 'stars'),
  githubUpdated: LocalizedText(es: 'Actualizado', en: 'Updated'),
  githubUnavailable: LocalizedText(
    es: 'GitHub API no disponible, usando datos locales.',
    en: 'GitHub API unavailable, showing local data.',
  ),
  footerLine: LocalizedText(
    es: 'Diseñado en Flutter Web con contenido bilingüe y CV basado en Markdown.',
    en: 'Designed in Flutter Web with bilingual content and a Markdown-based resume.',
  ),
);
