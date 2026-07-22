## 1. ArtifactGroup

The `ArtifactGroup` entity acts as a logical container. Before you can secure an artifact (like a screen, service, or entity), you must group it.

* **Purpose:** It defines a named collection of artifacts, giving you a single reference point for assigning permissions later.
* **Key Fields:**
* `artifactGroupId`: The unique identifier for the group (e.g., `EXAMPLE_APP`).
* `description`: A human-readable summary of what the group contains.

## 2. ArtifactGroupMember

The `ArtifactGroupMember` entity populates your `ArtifactGroup`. It tells the system exactly which specific artifacts belong inside the container you just created.

* **Purpose:** It maps individual artifacts or broad patterns of artifacts to an `ArtifactGroup`.
* **Key Fields & Concepts:**
* `artifactName`: The exact path (e.g., `component://example/screen/ExampleApp.xml`) or a package name.
* `nameIsPattern`: If set to `Y`, the `artifactName` acts as a regular expression. This is highly useful for grouping entire packages of services or entities at once (e.g., `org.moqui.example..*`).
* `artifactTypeEnumId`: Specifies the type of artifact being added (e.g., `AT_XML_SCREEN` for user interface screens or `AT_SERVICE` for backend services).
* `inheritAuthz`: When set to `Y`, it allows child artifacts (like sub-screens within a root screen) to inherit the security rules of this group.

## 3. ArtifactAuthz

The `ArtifactAuthz` entity is where the actual security rules are applied. It connects the `ArtifactGroup` to a specific user role and defines exactly what those users are allowed to do.

* **Purpose:** It grants or denies permissions to a user group for all artifacts contained in the `ArtifactGroup`.
* **Key Fields & Concepts:**
* `userGroupId`: The user role receiving the permission (e.g., `ADMIN` or `EXAMPLE_VIEWER`).
* `authzActionEnumId`: Defines *what* the user can do. Options include View (`AUTHZA_VIEW`), Create, Update, Delete, or All (`AUTHZA_ALL`).
* `authzTypeEnumId`: Defines the strictness of the rule.
* **Always** (`AUTHZT_ALWAYS`): Grants access and overrides any "deny" rules.
* **Allow** (`AUTHZT_ALLOW`): Grants access, but can be overridden by a specific "deny" rule.
* **Deny** (`AUTHZT_DENY`): Explicitly blocks access.

---

### Advanced / Record-Level Entity

While the three entities above secure broad artifacts (like full screens or entire tables), the text also introduces a specialized fourth entity for granular data security:

**ArtifactAuthzRecord**
This is used when you need **row-level security** (restricting access to specific records within an entity, rather than the whole entity). It links the currently logged-in `userId` to specific data rows using a view entity, ensuring users can only perform actions on records they explicitly own or have access to.
